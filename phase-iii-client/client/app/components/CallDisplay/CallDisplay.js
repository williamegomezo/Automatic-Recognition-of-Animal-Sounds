// @flow
import React, { Component } from 'react';
import Paper from '@material-ui/core/Paper';
import CustomButton from '../CustomButton/CustomButton';
import CustomPanel from '../CustomPanel/CustomPanel';

class CallDisplay extends Component {
  render() {
    const { buttons } = this.props;
    return (
      <Paper className="col-xs-off-1 col-xs-22 callDisplay__container">
        <img
          className="col-xs-off-1 col-xs-22 callDisplay__img"
          src="https://via.placeholder.com/400.png"
          alt="Call spectrogram"
        />
        <div className="callDisplay__buttons">
          {buttons &&
            buttons.map((button, key) => (
              <CustomButton
                key={key}
                name={button.name}
                tooltips={button.tooltips}
                onClick={button.callbacks.map(c => this[c])}
              />
            ))}
        </div>
        <CustomPanel />
      </Paper>
    );
  }
}

export default CallDisplay;
