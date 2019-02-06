// @flow
import React, { Component } from 'react';
import { connect } from 'react-redux';
import Button from '@material-ui/core/Button';
import Divider from '@material-ui/core/Divider';
import Paper from '@material-ui/core/Paper';
import Snackbar from '@material-ui/core/Snackbar';
import { remote } from 'electron';
import fs from 'fs';
import path from 'path';
import CustomList from '../components/CustomList/CustomList';
import CustomPanel from '../components/CustomPanel/CustomPanel';
import DialogLoader from '../components/DialogLoader/DialogLoader';
import fileButtons from '../constants/FileButtons.json';
import speciesButtons from '../constants/SpeciesButtons.json';
import { changeDir, setSpecies } from '../store/actions';
import { getData } from '../utils/promises';
import routes from '../constants/routes.json';

class Home extends Component {
  constructor(props) {
    super(props);

    this.state = {
      error: false,
      errorMsg: '',
      dir: '',
      files: [],
      species: [],
      selectedSpecies: [],
      addingSpeciesDialog: false
    };
  }

  componentDidMount() {
    this.getSpecies();
  }

  selectDirectory = () => {
    remote.dialog.showOpenDialog(
      {
        properties: ['openDirectory']
      },
      filePaths => {
        fs.readdir(filePaths[0], (err, files) => {
          if (err) throw err;
          const filteredFiles = files.filter(
            f => path.extname(f) === '.mp3' || path.extname(f) === '.wav'
          );
          this.props.changeDir(filePaths[0]);
          this.setState({ dir: filePaths[0], files: filteredFiles });
        });
      }
    );
  };

  getSpecies = () => {
    getData('get-species', 'GET').then(resp => {
      const formatedSpecies = resp.map(specie => ({
        'Species Name': specie['name'],
        'Start [s]': specie['metadata'][1],
        'End [s]': specie['metadata'][2],
        'Min. Freq. [Hz]': specie['metadata'][4],
        'Max. Freq. [Hz]': specie['metadata'][5],
        'Dom. Freq. [Hz]': specie['metadata'][6],
        'Avg. call duration [s]': specie['metadata'][3],
        'audio path': specie['audio_path'],
        'image path': specie['image_path']
      }));
      this.setState({ species: resp.map(specie => specie['name']) });
      this.props.setSpecies(formatedSpecies);
    });
  };

  addingSpecies = () => {
    this.setState({ addingSpeciesDialog: true });
  };

  requestClusters = () => {
    const { dir, files } = this.state;
    if (files.length > 0) {
      getData('get-clusters', 'POST', {
        dir,
        files
      }).then(resp => {
        this.props.history.push(routes.TABLE, resp);
      });
    } else {
      this.setState(
        {
          addingSpeciesDialog: false,
          error: true,
          errorMsg: 'No files in left panel'
        },
        () => {
          setTimeout(() => {
            this.setState({ error: false, errorMsg: '' });
          }, 2000);
        }
      );
    }
  };

  searchClusters = () => {
    const { dir, files, species, selectedSpecies } = this.state;
    if (files.length > 0) {
      getData('search-clusters', 'POST', {
        dir,
        files,
        species: species.filter((s, id) => selectedSpecies.includes(id))
      }).then(resp => {
        this.props.history.push(routes.TABLE, resp);
      });
    } else {
      this.setState(
        {
          addingSpeciesDialog: false,
          error: true,
          errorMsg: 'No files in left panel'
        },
        () => {
          setTimeout(() => {
            this.setState({ error: false, errorMsg: '' });
          }, 2000);
        }
      );
    }
  };

  selectionChange = (id, checked) => {
    const { selectedSpecies } = this.state;
    if (!checked) {
      this.setState({ selectedSpecies: [...selectedSpecies, id] });
    } else {
      this.setState({
        selectedSpecies: selectedSpecies.filter(value => value !== id)
      });
    }
  };

  render() {
    const {
      dir,
      files,
      species,
      addingSpeciesDialog,
      error,
      errorMsg,
      selectedSpecies
    } = this.state;
    const tree = dir.split('/');
    return (
      <div className="column col-xs-24 center-xs" data-tid="container">
        <h1>Aureas</h1>
        <div className="row col-xs-24 center-xs">
          <div className="col-xs-11">
            <Paper elevation={1}>
              <div className="list__container">
                <h2 className="list__title">Files</h2>
                <Button variant="contained" onClick={this.selectDirectory}>
                  Select directory
                </Button>
                <h3>Directory:</h3>
                <span> {`...${tree.slice(tree.length - 2).join('/')}`}</span>
                <CustomPanel
                  info={[
                    {
                      label: 'Number of files',
                      value: files.length
                    },
                    {
                      label: 'Years',
                      value:
                        files.length > 0
                          ? this.uniqueYears(files).join(', ')
                          : 0
                    },
                    {
                      label: 'Months',
                      value:
                        files.length > 0
                          ? this.uniqueMonths(files).join(', ')
                          : 0
                    },
                    {
                      label: 'Days',
                      value:
                        files.length > 0 ? this.uniqueDays(files).join(', ') : 0
                    }
                  ]}
                />
                <Divider />
                <CustomList dir={dir} buttons={fileButtons} items={files} />
              </div>
            </Paper>
          </div>
          <div className="col-xs-off-1 col-xs-11 row-xs-24 column">
            <div className="row-xs-16">
              <Paper className="list__container" elevation={1}>
                <h2 className="list__title">Species</h2>
                <CustomList
                  checkbox
                  buttons={speciesButtons}
                  items={species}
                  addButton={{
                    text: 'Add species',
                    callback: () => {
                      this.addingSpecies();
                      this.requestClusters();
                    }
                  }}
                  selectedSpecies={selectedSpecies}
                  selectionChange={this.selectionChange}
                />
              </Paper>
            </div>
            <div className="row-xs-2" />
            <div className="row-xs-2">
              <Button variant="contained" onClick={this.searchClusters}>
                SEARCH
              </Button>
            </div>
          </div>
        </div>
        <Snackbar
          anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
          open={error}
          message={errorMsg}
        />
        <DialogLoader
          open={addingSpeciesDialog}
          progress={50}
          title={'Looking for new species...'}
          content={'Segmentation of files'}
          cancelCallback={() => {}}
        />
      </div>
    );
  }

  uniqueYears(data) {
    const years = data.map(datum =>
      Number(datum.split('_')[1].substring(0, 4))
    );
    return years
      .filter((d, i) => years.indexOf(d) === i)
      .sort((a, b) => (a > b ? 1 : -1));
  }

  uniqueMonths(data) {
    const months = data.map(datum =>
      Number(datum.split('_')[1].substring(4, 6))
    );
    return months
      .filter((d, i) => months.indexOf(d) === i)
      .sort((a, b) => (a > b ? 1 : -1));
  }

  uniqueDays(data) {
    const days = data.map(datum => Number(datum.split('_')[1].substring(6, 8)));
    return days
      .filter((d, i) => days.indexOf(d) === i)
      .sort((a, b) => (a > b ? 1 : -1));
  }
}

function mapDispatchToProps(dispatch) {
  return {
    changeDir: value => dispatch(changeDir(value)),
    setSpecies: value => dispatch(setSpecies(value))
  };
}

export default connect(
  null,
  mapDispatchToProps
)(Home);
