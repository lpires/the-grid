/** @jsx React.DOM */

module.exports = React.createClass({
    render: function() {
        return (
        	<td className="cell-status">{this.props.status}</td>
        )
    }
});