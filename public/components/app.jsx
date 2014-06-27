/** @jsx React.DOM */
var $ = require('jquery')
var Grid = require('./Grid.jsx');
var getSource = function (){
	var path = '/commands',
		steps = [{key: 'C', x: 5, y: 3},
				 {key: 'P', x1: 1, y1: 1, c1: 'E'},
				 {key: 'R'},{key: 'F'},{key: 'R'},{key: 'F'},{key: 'R'},{key: 'F'},{key: 'R'},{key: 'F'}
				 ];
		
	return steps.map(function(step) {	
		var source =  null;	 
		$.each(Object.keys(step), function(idx,key) {
			source = !source ? path + "?" : source + "&"
  			source += key+"="+step[key]
		});
		return source;
	});
}


React.renderComponent(	
	<Grid source={getSource()}/>,
    document.body
);

