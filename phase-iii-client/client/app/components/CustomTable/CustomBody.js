import React from 'react';
import { connect } from 'react-redux';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import TableBody from '@material-ui/core/TableBody';
import Checkbox from '@material-ui/core/Checkbox';
import { changeSelection } from '../../store/actions';
import { stableSort, getSorting } from './utils';

class CustomBody extends React.Component {
  constructor(props) {
    super(props);
    this.isCurrentClicked = this.isCurrentClicked.bind(this);
  }

  componentDidMount() {
    const { data, moduleType, changeSelection } = this.props;
    changeSelection({ [moduleType]: data[0] });
  }

  isCurrentClicked(id) {
    const { currentClicked, moduleType } = this.props;
    return (
      currentClicked[moduleType] && currentClicked[moduleType]['id'] === id
    );
  }

  render() {
    const {
      data,
      order,
      checkbox,
      orderBy,
      page,
      rowsPerPage,
      emptyRows,
      headers,
      isSelected,
      handleClick,
      moduleType
    } = this.props;

    return (
      <TableBody>
        {stableSort(data, getSorting(order, orderBy))
          .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
          .map(n => {
            const isSelectedValue = isSelected(n.id);
            const isCurrentValue = this.isCurrentClicked(n.id);
            return (
              <TableRow
                hover
                role="checkbox"
                onClick={() => this.props.changeSelection({ [moduleType]: n })}
                aria-checked={isSelectedValue}
                tabIndex={-1}
                key={n.id}
                selected={isCurrentValue}
              >
                {checkbox && (
                  <TableCell padding="checkbox">
                    <Checkbox
                      onChange={event => handleClick(event, n.id)}
                      checked={isSelectedValue}
                    />
                  </TableCell>
                )}
                {headers.map(h => (
                  <TableCell
                    className="customTable__cell"
                    style={{ padding: '4px 10px' }}
                    key={n.id + h.label}
                    align={h.numeric ? 'right' : 'left'}
                  >
                    {n[h['label']]}
                  </TableCell>
                ))}
              </TableRow>
            );
          })}
        {emptyRows > 0 && (
          <TableRow style={{ height: 49 * emptyRows }}>
            <TableCell colSpan={6} />
          </TableRow>
        )}
      </TableBody>
    );
  }
}

const mapStateToProps = state => {
  return { currentClicked: state.tableReducer.selected };
};

function mapDispatchToProps(dispatch) {
  return {
    changeSelection: item => dispatch(changeSelection(item))
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(CustomBody);
