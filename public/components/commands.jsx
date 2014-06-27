/** @jsx React.DOM */

module.exports = React.createClass({
    render: function() {
		var commandsNodes = this.props.commands.map(function (command) {
			return <p className="command">{command.key} {command.x} {command.y}</p>;
		});
        return (
        	<p className="commands">{commandsNodes}</p>
        )
    }
});