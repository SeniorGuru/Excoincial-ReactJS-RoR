import React, { useState, forwardRef } from "react";
import PropTypes from "prop-types";
import MaterialTable from 'material-table';
import InputLabel from '@material-ui/core/InputLabel';
import FormControl from '@material-ui/core/FormControl';
import Select from '@material-ui/core/Select';
import {
  withStyles,
  withWidth,
  Tabs,
  Tab
} from "@material-ui/core";
import AddBox from '@material-ui/icons/AddBox';
import ArrowDownward from '@material-ui/icons/ArrowDownward';
import Check from '@material-ui/icons/Check';
import ChevronLeft from '@material-ui/icons/ChevronLeft';
import ChevronRight from '@material-ui/icons/ChevronRight';
import Clear from '@material-ui/icons/Clear';
import DeleteOutline from '@material-ui/icons/DeleteOutline';
import Edit from '@material-ui/icons/Edit';
import FilterList from '@material-ui/icons/FilterList';
import FirstPage from '@material-ui/icons/FirstPage';
import LastPage from '@material-ui/icons/LastPage';
import Remove from '@material-ui/icons/Remove';
import SaveAlt from '@material-ui/icons/SaveAlt';
import Search from '@material-ui/icons/Search';
import ViewColumn from '@material-ui/icons/ViewColumn';

const tableIcons = {
  Add: forwardRef((props, ref) => <AddBox {...props} ref={ref} />),
  Check: forwardRef((props, ref) => <Check {...props} ref={ref} />),
  Clear: forwardRef((props, ref) => <Clear {...props} ref={ref} />),
  Delete: forwardRef((props, ref) => <DeleteOutline {...props} ref={ref} />),
  DetailPanel: forwardRef((props, ref) => <ChevronRight {...props} ref={ref} />),
  Edit: forwardRef((props, ref) => <Edit {...props} ref={ref} />),
  Export: forwardRef((props, ref) => <SaveAlt {...props} ref={ref} />),
  Filter: forwardRef((props, ref) => <FilterList {...props} ref={ref} />),
  FirstPage: forwardRef((props, ref) => <FirstPage {...props} ref={ref} />),
  LastPage: forwardRef((props, ref) => <LastPage {...props} ref={ref} />),
  NextPage: forwardRef((props, ref) => <ChevronRight {...props} ref={ref} />),
  PreviousPage: forwardRef((props, ref) => <ChevronLeft {...props} ref={ref} />),
  ResetSearch: forwardRef((props, ref) => <Clear {...props} ref={ref} />),
  Search: forwardRef((props, ref) => <Search {...props} ref={ref}/>),
  SortArrow: forwardRef((props, ref) => <ArrowDownward {...props} ref={ref} />),
  ThirdStateCheck: forwardRef((props, ref) => <Remove {...props} ref={ref} />),
  ViewColumn: forwardRef((props, ref) => <ViewColumn {...props} ref={ref} />)
};


const styles = theme => ({
  transactions: {
    overflowX: `scroll`,
    backgroundColor: theme.palette.background.default,
    display: `flex`,
    justifyContent: `center`,
    padding: `25px 10%`,
    [theme.breakpoints.down("md")]:{
      padding: `5px 5px`,
      justifyContent: `center`,
      width:'100%',
    },
    [theme.breakpoints.down("sm")]:{
      padding: `5px 5px`,
      justifyContent: `left`,
      width:'100%',
    },
  },
  materialTable: {
    overflowX: `scroll`,
    width: '100%',
  },
  tabletab:{
    [theme.breakpoints.down("sm")]:{
      paddingLeft:3,
      paddingRight:3,
      fontSize:`0.8rem`,
    },
  },
  tableheader:{
    textAlign: `center`,
    [theme.breakpoints.down("md")]:{
      paddingLeft:5,
      paddingRight:5,
      fontSize:`0.6rem`,
    },
    [theme.breakpoints.down("sm")]:{
      paddingLeft:5,
      paddingRight:5,
      fontSize:`0.6rem`,
    },
  },
  formControl: {
    margin: theme.spacing(1),
    paddingLeft: 5,
    border:`solid`,
    borderWidth:`thin`,
    borderRadius:10,
    height:20,
    width:48,
    marginTop:12,
    marginLeft:0,
  },
  formselect:{
    height:20,
    fontSize:`0.8rem`,
    '&::before':{
      borderBottom:0,
    },
    '&::after':{
      borderBottom:0,
    },
    [theme.breakpoints.down("md")]:{
      fontSize:`0.5rem`,
    },
    [theme.breakpoints.down("sm")]:{
      fontSize:`0.5rem`,
    },
  },
  icon:{
    position:'absolute'
  },
});

function HeadSection(props) {
  const { classes } = props;
  const [ tabIndex, setTabIndex] = useState(0);
  const [ marketData, setMarketData] = useState([]);
  const [state, setState] = React.useState({
    name: 'all',
    name1: 'all',
  });
  const handleChange1 = (event) => {
    const name = event.target.name;
    setState({
      ...state,
      [name]: event.target.value,
    });
  };
  const handleChange2 = (event) => {
    const name1 = event.target.name1;
    setState({
      ...state,
      [name1]: event.target.value,
    });
  };
  const handleChange = (event, newValue) => {
    setTabIndex(newValue);
  };

  return (
    <div className={classes.transactions}>
      <MaterialTable
        icons={tableIcons}
        className={classes.materialTable}
        localization={{
          toolbar: {
              searchPlaceholder: "Search coin name"
          },
        }}
        title={
        <Tabs
          value={tabIndex}
          indicatorColor="primary"
          textColor="primary"
          onChange={handleChange}
        >
          <Tab label="Favorites" className={classes.tabletab} />
          <Tab label="EXL" className={classes.tabletab} />
          <Tab label="AFCASH" className={classes.tabletab} />
          <Tab label="BTC" className={classes.tabletab} />
          <Tab label="ALTS" className={classes.tabletab} />
          <FormControl className={classes.formControl}>
            <Select
              native
              value={state.name}
              onChange={handleChange1}
              inputProps={{
                name: 'all',
                id: 'alt-all',
              }}
              className={classes.formselect}
            >
              <option value={'all'}>All</option>
              <option value={'alts'}>ALTS</option>
              {/* <option value={20}>Twenty</option>
              <option value={30}>Thirty</option> */}
            </Select>
          </FormControl>
          <Tab label="FIAT" className={classes.tabletab} />
          <FormControl className={classes.formControl}>
            <Select
              native
              value={state.name1}
              onChange={handleChange2}
              inputProps={{
                name1: 'all',
                id: 'alt-all',
              }}
              className={classes.formselect}
            >
              <option value={'all'}>All</option>
              <option value={'fiat'}>FIAT</option>
              {/* <option value={20}>Twenty</option>
              <option value={30}>Thirty</option> */}
            </Select>
          </FormControl>
        </Tabs>}
        options={{
          search: true,
          tableLayout: `auto`,
          pageSize: 20,
          pageSizeOptions: [20,50,100,200]
        }}
        columns={[
          {title: 'Pair', field: 'pair', headerStyle: {textAlign: `center`}},
          {title: 'Coin', field: 'coin', headerStyle: {textAlign: `center`}},
          {title: 'Last Price', field: 'lastPrice', headerStyle: {textAlign: `center`}},
          {title: '24h Change', field: '24hChange', headerStyle: {textAlign: `center`}},
          {title: '24h High', field: '24hHigh', headerStyle: {textAlign: `center`}},
          {title: '24h Low', field: '24hLow', headerStyle: {textAlign: `center`}},
          {title: 'Market Cap', field: 'MarketCap', headerStyle: {textAlign: `center`}},
          {title: '24h Volume', field: '24hVolume', headerStyle: {textAlign: `right`}},
        ]}
        data = {marketData}
      />
    </div>
  );
}

HeadSection.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(HeadSection)
);
