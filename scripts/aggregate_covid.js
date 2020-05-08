#!/usr/bin/node
'use strict';

const path = require('path');
const fs = require('fs');
const directoryPath = path.join(__dirname, '../data');

function readFeatures(fname) {
	let rawdata = fs.readFileSync(fname);
	return JSON.parse(rawdata).features;
}

function main() {
	fs.readdir(directoryPath, function (err, files) {
		var data = {}
		if (err) {
			return console.log('Unable to scan directory: ' + err);
		} 
		files.forEach(function (file) {
			if (file.startsWith('departements-france-') && file.endsWith('.json')) {
				let day = file.substr(20,10)
				let tmp = readFeatures(path.join(directoryPath,file))
				tmp.forEach(function(d) { 
					let p = d.properties
					let c = p.Code
					data[c] = data[c] || []
					delete p.Code;
					delete p["Country/Region"]
					delete p["Province/State"]
					p.Confirmed = p.Confirmed || 0
					p.Recovered = p.Recovered || 0
					p.Severe = p.Severe || 0
					p.Deaths = p.Deaths || 0
					p.day = day
					data[c].push(p)
				} )
			}
		});
		fs.writeFile(path.join(directoryPath,'aggregated.json'),JSON.stringify(data),function(err){
			if(err) throw err;
		})
	});
}

main()

