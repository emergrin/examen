var json2csv = require('json2csv');
var fs = require('fs');
var fields = ['Title','Year','Rated','Released','Runtime','Genre','Director','Writer','Actors','Plot','Language','Country','Awards','Poster','Source','Value','Metascore','imdbRating','imdbVotes','imdbID','Type','DVD','BoxOffice','Production','Website','Response'];
var myjson = require('./test.json');
var csv = json2csv({ data: myjson, fields: fields });

fs.writeFile('./file.csv', csv, function(err) {
  if (err) throw err;
  console.log('file saved');
});
