import * as React from 'react';
import { autobind } from 'utils';

/** Button */
class Button extends React.Component {

    props:{
        /** Value */
        value:string,
        /** Kind */
        kind?:('dashed'),
        /** onChange */
        onClick?:() => void
    };

    render() {

        if (this.props.kind === 'dashed') {
            return (
                <input className="input input-button dashed" type="button" value={this.props.value} onClick={this.handleClick} />
            );
        } else {
            return (
                <input className="input input-button" type="button" value={this.props.value} onClick={this.handleClick} />
            );
        }

    } //render

    @autobind handleClick(e:any) {

        if (this.props.onClick) {
            this.props.onClick();
        }

    } //handleClick

}

export default Button;
