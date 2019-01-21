// @flow
import React, { Component } from 'react';
import Gradient from '@material-ui/icons/Gradient';
import PlayArrow from '@material-ui/icons/PlayArrow';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';

type Props = {
  tooltip: string,
  name: string,
  onClick: any
};

export default class CustomButton extends Component<Props> {
  props: Props;

  render() {
    const { name, tooltip, onClick } = this.props;
    return (
      <Tooltip title={tooltip}>
        <IconButton aria-label={tooltip} onClick={onClick}>
          {name === 'PlayArrow' && <PlayArrow />}
          {name === 'Gradient' && <Gradient />}
        </IconButton>
      </Tooltip>
    );
  }
}
