var json2csv = require('json2csv');
var async = require('async');
var fs = require('fs');
var AWS = require('aws-sdk');
var util = require('util');
var fields = ['Title','Year','Rated','Released','Runtime','Genre','Director','Writer','Actors','Plot','Language','Country','Awards','Poster','Source','Value','Metascore','imdbRating','imdbVotes','imdbID','Type','DVD','BoxOffice','Production','Website','Response'];

// get reference to S3 client
var s3 = new AWS.S3();

exports.handler = function(event, context, callback) {
    // Read options from the event.
    console.log("Reading options from event:\n", util.inspect(event, {depth: 5}));
    var srcBucket = "original";
    var srcKey    = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));

    // Object key may have spaces or unicode non-ASCII characters.
    var dstBucket = "destino";
    var dstKey    = srcKey;

    // Sanity check: validate that source and destination are different buckets.
    if (srcBucket == dstBucket) {
        callback("Source and destination buckets are the same.");
        return;
    }
    // Download the image from S3, transform, and upload to a different S3 bucket.
    async.waterfall([
        function download(next) {
            // Download the image from S3 into a buffer.
            s3.getObject({
                    Bucket: srcBucket,
                    Key: srcKey
            },
                next);
            },
        function transform() {
          var csv = json2csv({ data: srcKey, fields: fields });
          fs.writeFile(dstKey, csv, function(err) {
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
