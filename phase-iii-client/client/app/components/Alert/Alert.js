// @flow
import React, { Component } from 'react';
import Dialog from '@material-ui/core/Dialog';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import Button from '@material-ui/core/Button';

class Alert extends Component {
  state = {
    open: false
  };

  componentWillReceiveProps(nextProps) {
    this.setState({ open: nextProps.open });
  }

  handleClose = text => {
    const {
      firstButtonText,
      firstButtonCallback,
      secondButtonCallback
    } = this.props;
    this.setState({ open: false }, () => {
      if (text === firstButtonText) {
        firstButtonCallback();
      } else {
        secondButtonCallback();
      }
    });
  };

  render() {
    const { title, content, firstButtonText, secondButtonText } = this.props;
    return (
      <Dialog
        open={this.state.open}
        onClose={this.handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">{title}</DialogTitle>
        <DialogContent>
          <DialogContentText id="alert-dialog-description">
            {content}
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button
            onClick={() => this.handleClose(firstButtonText)}
            color="primary"
          >
            {firstButtonText}
          </Button>
          <Button
            onClick={() => this.handleClose(secondButtonText)}
            color="primary"
            autoFocus
          >
            {secondButtonText}
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}

export default Alert;
