import React from 'react';
import { connect } from 'react-redux';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import TableBody from '@material-ui/core/TableBody';
import Checkbox from '@material-ui/core/Checkbox';
import { changeSelection } from '../../store/actions';
import { stableSort, getSorting } from './utils';

class CustomBody extends React.Component {
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
            const isSelectedClosure = isSelected(n.id);
            return (
              <TableRow
                hover
                role="checkbox"
                onClick={() => this.props.changeSelection({ [moduleType]: n })}
                aria-checked={isSelectedClosure}
                tabIndex={-1}
                key={n.id}
              >
                {checkbox && (
                  <TableCell padding="checkbox">
                    <Checkbox
                      onChange={event => handleClick(event, n.id)}
                      checked={isSelectedClosure}
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

function mapDispatchToProps(dispatch) {
  return {
    changeSelection: item => dispatch(changeSelection(item))
  };
}

export default connect(
  null,
  mapDispatchToProps
)(CustomBody);
