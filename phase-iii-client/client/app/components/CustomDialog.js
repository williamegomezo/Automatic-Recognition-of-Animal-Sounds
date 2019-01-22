// @flow
import React, { Component } from 'react';
import Dialog from '@material-ui/core/Dialog';

type Props = {
  open: boolean,
  handleClose: any
};

export default class CustomDialog extends Component<Props> {
  props: Props;

  render() {
    const { open, handleClose } = this.props;
    return (
      <Dialog open={open} onClose={handleClose}>
        <h1>Image</h1>
      </Dialog>
    );
  }
}
