// @flow
import React, { Component } from 'react';
import { connect } from 'react-redux';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import FormLabel from '@material-ui/core/FormLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';
import { changeRadio } from '../../store/actions';

class VariableSelect extends Component {
  constructor(props) {
    super(props);
    const { model, options } = props;

    this.state = {
      radioValue: options[0].label
    };

    this.radioChange = this.radioChange.bind(this);
    this.props.changeRadio({ [model]: options[0].label });
  }

  radioChange(event) {
    this.setState({ radioValue: event.target.value }, () => {
      const { model } = this.props;
      const { radioValue } = this.state;
      this.props.changeRadio({ [model]: radioValue });
    });
  }

  render() {
    const { title, model, options } = this.props;
    const { radioValue } = this.state;
    return (
      <div className="variableSelect__container">
        <FormControl component="fieldset">
          <FormLabel component="legend">{title}</FormLabel>
          <RadioGroup
            aria-label={model}
            name={model}
            value={radioValue}
            onChange={this.radioChange}
          >
            {options.map(o => (
              <FormControlLabel
                value={o.label}
                control={<Radio />}
                label={o.label}
              />
            ))}
          </RadioGroup>
        </FormControl>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return {
    changeRadio: item => dispatch(changeRadio(item))
  };
}

export default connect(
  null,
  mapDispatchToProps
)(VariableSelect);
