// @flow
import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import LinearProgress from '@material-ui/core/LinearProgress';

class DialogLoader extends Component {
  state = {
    open: false,
    progress: 0
  };

  componentWillReceiveProps(nextProps) {
    this.setState({ open: nextProps.open, progress: nextProps.progress });
  }

  handleClose = text => {
    const { cancelCallback } = this.props;
    this.setState({ open: false }, () => {
      cancelCallback();
    });
  };

  render() {
    const { title, content } = this.props;
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
        <LinearProgress
          color="secondary"
          variant="determinate"
          value={this.state.progress}
        />
        <DialogActions>
          <Button onClick={() => this.handleClose()} color="primary">
            {'Cancel'}
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}

export default DialogLoader;
