// @flow
import React, { Component } from 'react';
import Gradient from '@material-ui/icons/Gradient';
import PlayArrow from '@material-ui/icons/PlayArrow';
import Stop from '@material-ui/icons/Stop';
import GraphicEq from '@material-ui/icons/GraphicEq';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';

export default class CustomButton extends Component {
  state = {
    status: 0
  };

  ChangeState() {
    const { status } = this.state;
    if (status === 0) {
      this.setState({ status: 1 });
    } else {
      this.setState({ status: 0 });
    }
  }

  render() {
    const { status } = this.state;
    const { name, tooltips, onClick } = this.props;
    let tooltip;
    if (tooltips.length > 1) {
      tooltip = tooltips[status];
    } else if (tooltips.length > 0) {
      tooltip = tooltips[0];
    } else {
      tooltip = '';
    }
    return (
      <Tooltip title={tooltip}>
        <IconButton
          aria-label={tooltip}
          onClick={() => {
            this.ChangeState();
            if (onClick.length > 1) {
              onClick[status]();
            } else {
              onClick[0]();
            }
          }}
        >
          {name === 'PlayStop' &&
            (status === 1 && onClick.length > 1 ? <Stop /> : <PlayArrow />)}
          {name === 'Spectrogram' && <Gradient />}
          {name === 'RepresentativeCall' && <GraphicEq />}
        </IconButton>
      </Tooltip>
    );
  }
}
