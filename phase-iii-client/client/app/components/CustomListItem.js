// @flow
import React, { Component } from 'react';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';
import Checkbox from '@material-ui/core/Checkbox';
import CustomButton from './CustomButton';
import CustomDialog from './CustomDialog';

type Props = {
  primary: string,
  secondary: string,
  checkbox: boolean,
  buttons: array,
  dir: string
};

export default class CustomListItem extends Component<Props> {
  props: Props;

  constructor(props) {
    super(props);
    this.state = {
      spectrogramDialog: false
    };

    this.playItem = this.playItem.bind(this);
    this.getSpectrogram = this.getSpectrogram.bind(this);
    this.closeSpectrogram = this.closeSpectrogram.bind(this);
  }

  playItem() {
    const { primary, dir } = this.props;
    const audio = new Audio(`${dir}/${primary}`);
    audio.play();
  }

  getSpectrogram() {
    this.setState({ spectrogramDialog: true });
  }

  closeSpectrogram() {
    this.setState({ spectrogramDialog: false });
  }

  render() {
    const { primary, secondary, checkbox, buttons } = this.props;
    const { spectrogramDialog } = this.state;
    return (
      <ListItem dense button>
        <div className="row middle-xs col-xs-24">
          {buttons &&
            buttons.map(button => (
              <CustomButton
                name={button.name}
                tooltip={button.tooltip}
                onClick={this[button.callback]}
              />
            ))}
          {checkbox && <Checkbox tabIndex={-1} disableRipple />}
          <ListItemText primary={primary} secondary={secondary} />
        </div>
        <CustomDialog
          open={spectrogramDialog}
          handleClose={this.closeSpectrogram}
        />
      </ListItem>
    );
  }
}
