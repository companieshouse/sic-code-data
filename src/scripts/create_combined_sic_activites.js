/*
  This mongo script will recreate the combined_sic_activities collection from the following collections:
  - ons_economic_activity_sic_codes (using this as a base)
  - condensed_sic_codes
  - ch_economic_activity_sic_codes

  Adding additional fields to help the search 
  - sic_description (from condensed_sic_codes)
  - is_ch_activity (true if parent is ch_economic_activity_sic_codes)
  - activity_description_lower_case (lower case of the activity_description field)
  - generation_date has been added to keep track of when records have been created


*/


db.combined_sic_activities.drop()
db.ons_combined_sic_activities.aggregate([ {
    $addFields: {
       "generation_date": new Date()
    }
 },
 {$out : "combined_sic_activities"}])

db.ch_economic_activity_sic_codes.aggregate([
    { $lookup:
        {
           from: "condensed_sic_codes",
           localField: "sic_code",
           foreignField: "sic_code",
           as: "sicRecord"
        }
    },
    {
        $unwind:"$sicRecord"
    },
    {
        $project:{
            "_id":1,
            "sic_code" : 1,
            "activity_description" : 1,
            "activity_description_lower_case" : { $toLower: "$activity_description"},
            "sic_description" : "$sicRecord.sic_description",
            "is_ch_activity" : {$toBool: true}
        }
    },
    {
        $project:{
            "_id":1,
            "sic_code" : 1,
            "activity_description" : 1,
            "activity_description_lower_case" : 1,
            "activity_description_search_field_a" : { $replaceAll: { input: "$activity_description_lower_case" , find: "(", replacement: "" } }            ,
            "sic_description" : 1,
            "is_ch_activity" : 1
        }
    },
    {
        $project:{
            "_id":1,
            "sic_code" : 1,
            "activity_description" : 1,
            "activity_description_search_field" : { $replaceAll: { input: "$activity_description_search_field_a" , find: ")", replacement: "" } }            ,
            "sic_description" : 1,
            "is_ch_activity" : 1,
            "count": { $literal : 1 }
        },
    },
    { $merge : "combined_sic_activities"}

    
]);


