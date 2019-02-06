// @flow
import React, { Component } from 'react';
import { connect } from 'react-redux';
import ListItem from '@material-ui/core/ListItem';
import Checkbox from '@material-ui/core/Checkbox';
import CustomButton from '../CustomButton/CustomButton';
import CustomDialog from '../CustomDialog/CustomDialog';
import { changeSelection } from '../../store/actions';

class CustomListItem extends Component {
  constructor(props) {
    super(props);
    this.state = {
      modeDialog: '',
      dialogOpened: false,
      checked: this.props.item.checked,
      audio: null
    };

    this.playItem = this.playItem.bind(this);
    this.stopItem = this.stopItem.bind(this);
    this.toggleCheck = this.toggleCheck.bind(this);
    this.getSpectrogram = this.getSpectrogram.bind(this);
    this.getRepresentiveCall = this.getRepresentiveCall.bind(this);
    this.openDialog = this.openDialog.bind(this);
    this.closeDialog = this.closeDialog.bind(this);
  }

  playItem() {
    const { item, dir } = this.props;
    this.setState({ audio: new Audio(`${dir}/${item.text}`) }, () => {
      this.state.audio.play();
    });
  }

  stopItem() {
    this.state.audio.pause();
  }

  getSpectrogram(id) {
    this.setState({ modeDialog: 'SpectrogramDisplay' });
    this.openDialog();
  }

  getRepresentiveCall(id) {
    this.props.changeSelection({ list_initial: this.props.species[id] });
    this.setState({ modeDialog: 'CallDisplay' });
    this.openDialog();
  }

  openDialog() {
    this.setState({ dialogOpened: true });
  }

  closeDialog() {
    this.setState({ dialogOpened: false });
  }

  toggleCheck() {
    const { checked } = this.state;
    this.setState({ checked: !checked });
  }

  render() {
    const {
      id,
      item,
      checkbox,
      buttons,
      toogleChange,
      selectionChange
    } = this.props;
    const { modeDialog, dialogOpened, checked } = this.state;
    return (
      <ListItem dense button>
        <div className="row middle-xs col-xs-24">
          {buttons &&
            buttons.map((button, key) => (
              <CustomButton
                key={key}
                name={button.name}
                tooltips={button.tooltips}
                onClick={button.callbacks.map(callbackName => {
                  return () => this[callbackName](id);
                })}
              />
            ))}
          <div onClick={this.toggleCheck}>
            {checkbox && (
              <Checkbox
                checked={checked}
                tabIndex={-1}
                onChange={() => {
                  this.toggleCheck();
                  selectionChange(id, checked);
                }}
                disableRipple
              />
            )}
            <span style={styles.text}>{item.text}</span>
          </div>
        </div>
        <CustomDialog
          open={dialogOpened}
          handleClose={this.closeDialog}
          mode={modeDialog}
        />
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

const mapStateToProps = state => {
  console.log(state);
  return {
    species: state.speciesReducer.species
  };
};

function mapDispatchToProps(dispatch) {
  return {
    changeSelection: item => dispatch(changeSelection(item))
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(CustomListItem);
