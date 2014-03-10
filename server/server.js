var marked      = require('marked'),
	pygmentize  = require('pygmentize-bundled'),
	renderer    = new marked.Renderer(),
    express     = require('express'),
    app         = express(),
    port        = (process.argv.length > 2 ? parseInt(process.argv[2]) : 12345);

renderer.code = function(code, language) {
    return code;
};

marked.setOptions({
    highlight: function (code, lang, callback) {
        pygmentize({ lang: lang, format: 'html' }, code, function (err, result) {
            callback(err, result ? result.toString() : null);
        });
    }
});

app.use(express.bodyParser());
app.post('/',function(req, res) {
	var data = req.body.data;
	if (data) {
		marked(data, {renderer : renderer}, function(err, content) {
	    	if (err) {
	    		res.end(err);
	    	} else {
	    		res.end(content);
	    	}
	    });
	} else {
		res.end('Stahp it');
	}
});

app.listen(port);
