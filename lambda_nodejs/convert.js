var json2csv = require('json2csv');
var fs = require('fs');
var async = require('async');
var AWS = require('aws-sdk');
var gm = require('gm')
            .subClass({ imageMagick: true }); // Enable ImageMagick integration.
var util = require('util');
var fields = ['Title','Year','Rated','Released','Runtime','Genre','Director','Writer','Actors','Plot','Language','Country','Awards','Poster','Source','Value','Metascore','imdbRating','imdbVotes','imdbID','Type','DVD','BoxOffice','Production','Website','Response'];

var myjson = require('./test.json');



// get reference to S3 client
var s3 = new AWS.S3();

exports.handler = function(event, context, callback) {
    // Read options from the event.
    console.log("Reading options from event:\n", util.inspect(event, {depth: 5}));
    var srcBucket = event.Records[0].s3.bucket.name;
    // Object key may have spaces or unicode non-ASCII characters.
    var srcKey    =
    decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));
    var dstBucket = srcBucket + "resized";
    var dstKey    = "resized-" + srcKey;

    // Sanity check: validate that source and destination are different buckets.
    if (srcBucket == dstBucket) {
        callback("Source and destination buckets are the same.");
        return;
    }

        function transform(response, next) {
          var csv = json2csv({ data: myjson, fields: fields });
          fs.writeFile('./file.csv', csv, function(err) {
            if (err) throw err;
            console.log('file saved');
          });
        },
        function upload(contentType, data, next) {
            // Stream the transformed image to a different S3 bucket.
            s3.putObject({
                    Bucket: dstBucket,
                    Key: dstKey,
                    Body: data,
                    ContentType: contentType
                },
                next);
            }
        ], function (err) {
            if (err) {
                console.error(
                    ' You have a error: ' + err
                );
            } else {
                console.log(
                    'All OK'
                );
            }

            callback(null, "message");
        }
    );
};
