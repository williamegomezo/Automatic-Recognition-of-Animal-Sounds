// @flow
import React, { Component } from 'react';
import { connect } from 'react-redux';
import Paper from '@material-ui/core/Paper';
import CircularProgress from '@material-ui/core/CircularProgress';
import CustomButton from '../CustomButton/CustomButton';
import CustomPanel from '../CustomPanel/CustomPanel';

class CallDisplay extends Component {
  render() {
    const { moduleType, headers, buttons, selectedItem } = this.props;
    const imageUrl =
      selectedItem[moduleType] && selectedItem[moduleType]['url']
        ? selectedItem[moduleType]['url'] + '.png'
        : 'https://via.placeholder.com/400.png';
    return (
      <Paper className="col-xs-off-1 col-xs-22 callDisplay__container">
        {selectedItem[moduleType] &&
        selectedItem[moduleType]['url'] &&
        imageUrl !== 'NONE.png' ? (
          <img
            className="col-xs-off-1 col-xs-22 callDisplay__img"
            src={imageUrl}
            alt="Call spectrogram"
          />
        ) : (
          <div className="callDisplay__progress">
            <CircularProgress />
            {imageUrl === 'NONE.png' && (
              <span> Segment to long to be processed </span>
            )}
          </div>
        )}
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
  return { selectedItem: state.tableReducer.selected };
};

export default connect(mapStateToProps)(CallDisplay);
