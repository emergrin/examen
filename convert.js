var jsontocsv = require('jsontocsv')

jsontocsv(test, test2, {header: false, whitelist: whitelistFields, separator: ','}, function (err) {
  if (!err) console.log('Success.')
});
