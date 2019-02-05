import React from 'react';
import { connect } from 'react-redux';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import TableBody from '@material-ui/core/TableBody';
import Checkbox from '@material-ui/core/Checkbox';
import { changeSelection } from '../../store/actions';
import { stableSort, getSorting } from './utils';
import { getData } from '../../utils/promises';

class CustomBody extends React.Component {
  constructor(props) {
    super(props);
    this.isCurrentClicked = this.isCurrentClicked.bind(this);
  }

  componentDidMount() {
    const { data } = this.props;
    this.requestImage(data[0]);
  }

  isCurrentClicked(id) {
    const { currentClicked, moduleType } = this.props;
    return (
      currentClicked[moduleType] && currentClicked[moduleType]['id'] === id
    );
  }

  requestImage = item => {
    const { moduleType, dir } = this.props;
    this.props.changeSelection({ [moduleType]: item });
    if (item['End [s]'] - item['Start [s]'] <= 5) {
      getData('get-segment-image', 'POST', {
        dir,
        filename: item['Filename'],
        start: item['Start [s]'],
        end: item['End [s]'],
        min_freq: item['Min. Freq. [Hz]'],
        max_freq: item['Max. Freq. [Hz]']
      })
        .then(resp => {
          item['url'] = resp['url'];
          this.props.changeSelection({ [moduleType]: item });
        })
        .catch(resp => {
          this.props.changeSelection({ [moduleType]: item });
        });
    } else {
      item['url'] = 'NONE';
      this.props.changeSelection({ [moduleType]: item });
    }
  };

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
      handleClick
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
                    onClick={() => this.requestImage(n)}
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
  return {
    currentClicked: state.tableReducer.selected,
    dir: state.dirReducer.dir
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
)(CustomBody);
