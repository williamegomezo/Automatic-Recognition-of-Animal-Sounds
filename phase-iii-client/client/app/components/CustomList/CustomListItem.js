// @flow
import React, { Component } from 'react';
import ListItem from '@material-ui/core/ListItem';
import Checkbox from '@material-ui/core/Checkbox';
import CustomButton from '../CustomButton/CustomButton';
import CustomDialog from '../CustomDialog/CustomDialog';

export default class CustomListItem extends Component {
  constructor(props) {
    super(props);
    this.state = {
      dialogOpened: false,
      checked: false
    };

    this.playItem = this.playItem.bind(this);
    this.toggleCheck = this.toggleCheck.bind(this);
    this.getSpectrogram = this.getSpectrogram.bind(this);
    this.getRepresentiveCall = this.getRepresentiveCall.bind(this);
    this.openDialog = this.openDialog.bind(this);
    this.closeDialog = this.closeDialog.bind(this);
  }

  toggleCheck() {
    const { checked } = this.state;
    this.setState({ checked: !checked });
  }

  playItem() {
    const { primary, dir } = this.props;
    const audio = new Audio(`${dir}/${primary}`);
    audio.play();
  }

  getSpectrogram() {
    this.openDialog();
  }

  getRepresentiveCall() {
    this.openDialog();
  }

  openDialog() {
    this.setState({ dialogOpened: true });
  }

  closeDialog() {
    this.setState({ dialogOpened: false });
  }

  render() {
    const { primary, checkbox, buttons } = this.props;
    const { dialogOpened, checked } = this.state;
    return (
      <ListItem dense button>
        <div className="row middle-xs col-xs-24">
          {buttons &&
            buttons.map((button, key) => (
              <CustomButton
                key={key}
                name={button.name}
                tooltip={button.tooltip}
                onClick={this[button.callback]}
              />
            ))}
          <div onClick={this.toggleCheck}>
            {checkbox && (
              <Checkbox checked={checked} tabIndex={-1} disableRipple />
            )}
            <span style={styles.text}>{primary}</span>
          </div>
        </div>
        <CustomDialog open={dialogOpened} handleClose={this.closeDialog} />
      </ListItem>
    );
  }
}

const styles = {
  text: {
    flexBasis: 'calc(13 / 24 * 100%)',
    maxWidth: 'calc(13 / 24 * 100%)',
    fontFamily: 'Roboto',
    fontSize: '12px',
    overflow: 'hidden',
    textOverflow: 'ellipsis'
  }
};
