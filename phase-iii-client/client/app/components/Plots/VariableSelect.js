// @flow
import React, { Component } from 'react';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import FormControl from '@material-ui/core/FormControl';
import FormLabel from '@material-ui/core/FormLabel';
import Radio from '@material-ui/core/Radio';
import RadioGroup from '@material-ui/core/RadioGroup';

class VariableSelect extends Component {
  render() {
    const { title, model, options } = this.props;
    return (
      <FormControl component="fieldset">
        <FormLabel component="legend">{title}</FormLabel>
        <RadioGroup aria-label={model} name={model}>
          {options.map(o => (
            <FormControlLabel
              value={o.label}
              control={<Radio />}
              label={o.label}
            />
          ))}
        </RadioGroup>
      </FormControl>
    );
  }
}

export default VariableSelect;
