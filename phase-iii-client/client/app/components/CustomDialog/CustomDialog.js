// @flow
import React, { Component } from 'react';
import Dialog from '@material-ui/core/Dialog';

export default class CustomDialog extends Component {
  render() {
    const { open, handleClose } = this.props;
    return (
      <Dialog open={open} onClose={handleClose}>
        <h1>Image</h1>
      </Dialog>
    );
  }
}
