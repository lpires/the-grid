/** @jsx React.DOM */
var $ = require('jquery')
var Line = require('./Line.jsx');
var Commands = require('./Commands.jsx')


module.exports = React.createClass({
    onSuccess: function(results) {
        resp = JSON.parse(results)
        this.setState({
        	grid: resp.grid
        });
        this.props.source.shift();
        this.request(resp.grid, resp.x, resp.y, resp.x1, resp.y1);
    },

    request: function(grid, x, y, x1, y1) {
        if(this.props.source.length === 0) return;
       	var path = this.props.source[0]
       	if(!!grid) path += '&grid=' + JSON.stringify(grid);
       	if(x !== undefined) path += '&x=' + x;
       	if(y !== undefined) path += '&y=' + y;
       	if(x1 !== undefined) path += '&x1=' + x1;
        if(y1 !== undefined) path += '&y1=' + y1;
       	$.ajax({
       	   type: "PUT",
       	   url: path,
       	   contentType: "application/json",
       	   async:false,
       	   success: this.onSuccess
        })
    },
	
    getInitialState: function() {
       return {grid: []};
    },
	
	componentDidMount: function() {
        this.request()
	},
	  
    render: function() {
		var lineNodes = this.state.grid.map(function (line) {
			return <Line line={line}/>;
		});
        return (
			<Commands commands = {this.state.commands}/>,
			<table>
				<tr>
					{lineNodes}
			    </tr>
			</table>
        )
    }
});