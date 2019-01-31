// @flow
import React, { Component } from 'react';
import { connect } from 'react-redux';
import Paper from '@material-ui/core/Paper';
import CustomButton from '../CustomButton/CustomButton';
import CustomPanel from '../CustomPanel/CustomPanel';

class CallDisplay extends Component {
  render() {
    const { moduleType, headers, buttons, selectedItem } = this.props;
    console.log(selectedItem[moduleType]);
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
        <CustomPanel
          info={headers.map(h => ({
            label: h['label'],
            value: selectedItem[moduleType]
              ? selectedItem[moduleType][h['label']]
              : ''
          }))}
        />
      </Paper>
    );
  }
}

const mapStateToProps = state => {
  return { selectedItem: state.selected };
};

export default connect(mapStateToProps)(CallDisplay);
