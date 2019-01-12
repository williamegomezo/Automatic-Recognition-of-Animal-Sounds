// @flow
import React, { Component } from 'react';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import IconButton from '@material-ui/core/IconButton';
import PlayArrow from '@material-ui/icons/PlayArrow';
import Gradient from '@material-ui/icons/Gradient';
import Checkbox from '@material-ui/core/Checkbox';
import Tooltip from '@material-ui/core/Tooltip';

type Props = {
  primary: string,
  secondary: string
};

export default class CustomListItem extends Component<Props> {
  props: Props;

  render() {
    const { primary, secondary } = this.props;
    return (
      <ListItem role={undefined} dense button>
        <div className="row middle-xs col-xs-24">
          <Tooltip title="Play">
            <IconButton aria-label="Comments">
              <PlayArrow />
            </IconButton>
          </Tooltip>
          <Tooltip title="Spectrogram">
            <IconButton aria-label="Comments">
              <Gradient />
            </IconButton>
          </Tooltip>
          <Checkbox tabIndex={-1} disableRipple />
          <ListItemText primary={primary} secondary={secondary} />
        </div>
      </ListItem>
    );
  }
}
