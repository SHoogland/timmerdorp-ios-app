import { readFile, writeFile } from 'fs';

const configFile = './config/example.config.xcconfig';

readFile(configFile, 'utf8', function(err, data) {
	if (err) {
		// eslint-disable-next-line no-console
		return console.log(err);
	}

    let newConfig = data.replace(/parse_app_id/g, process.env.PARSE_APP_ID);
    newConfig= newConfig.replace(/parse_js_key/g, process.env.PARSE_JS_KEY);

    writeFile('./config/config.xcconfig', newConfig, 'utf8', function(err) {
        // eslint-disable-next-line no-console
        if (err) return console.log(err);
    });
});