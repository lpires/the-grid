/** @jsx React.DOM */

var Cell = require('./Cell.jsx');

module.exports = React.createClass({
    render: function() {
		var cellNodes = this.props.line.map(function (line) {
			return <td className="cell-status">{line}</td>;
		});
        return (
			<tr>
				{cellNodes}
        	</tr>
        )
    }
});