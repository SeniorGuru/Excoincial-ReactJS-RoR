import React, { Fragment } from "react";
import PropTypes from "prop-types";
import {
  withStyles,
  withWidth,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TableFooter,
  Paper
} from "@material-ui/core";

import Chart from './Chart';
import tableSectionImage from "../../../assets/images/table-bg.png";
import ChevronRightIcon from '@material-ui/icons/ChevronRight';
import BTCImage from "../../../assets/images/icons/1.png";
import ETHImage from "../../../assets/images/icons/2.png";
import XRPImage from "../../../assets/images/icons/3.png";
import BNBImage from "../../../assets/images/icons/4.png";
import BNBImage1 from "../../../assets/images/icons/5.png";

const styles = theme => ({
  tableSection: {
    background: `url(${tableSectionImage}) center no-repeat`,
    backgroundSize: `100% 100%`,
    height: '100%',
    paddingTop: `200px`,
    paddingBottom: `50px`,
  },
  table: {
    width: `70vw`,
    [theme.breakpoints.down("md")]:{
      width:'90vw',
    },
    [theme.breakpoints.down("sm")]:{
      width:'90vw',
    },
    marginLeft: `auto`,
    marginRight: `auto`,    
  },
  tableicon:{
    float:`left`,
    height:`50px`,
    marginRight:`10px`,
  },
  tableicontext:{
    lineHeight:`50px`,
  },
  tableiconmaintext:{
    fontWeight: `normal`,
    [theme.breakpoints.down("md")]:{
      marginLeft: 10,
    },
    [theme.breakpoints.down("sm")]:{
      marginLeft: 10,
    },
  },
  tableiconsubtext:{
    fontWeight: `normal`,
    [theme.breakpoints.down("md")]:{
      display:'none',
    },
    [theme.breakpoints.down("sm")]:{
      display:'none',
    },
  },
  tablenamecol:{
    paddingLeft:`20px`,
    [theme.breakpoints.down("md")]:{
      width:`10%`,
    },
    [theme.breakpoints.down("sm")]:{
      width:`10%`,
    },
  },
  tablelastpricecol:{
    [theme.breakpoints.down("md")]:{
      width:`35%`,
    },
    [theme.breakpoints.down("sm")]:{
      width:`35%`,
    },
  },
  icon:{
    position:'absolute'
  },
  tablemore:{
    color:`red`, 
    lineHeight:`24px`,
  },
});

function createData(icon, name, subname, lastPrice, charge, markets) {
  return { icon, name, subname, lastPrice, charge, markets };
}

const rows = [
  createData(BTCImage, 'BTC', '(Bitcoin)', '$ 9,566.23', '+ 1.88%', 24, 4.0),
  createData(ETHImage, 'ETH', '(Ethereum)', '$ 233.50', '+ 8.56%', 37, 4.3),
  createData(XRPImage, 'XRP', '(Ripple)', '$ 0.205670', '+ 4.23%', 24, 6.0),
  createData(BNBImage, 'BNB', '(BNB)', '$ 17.32', '+ 3.85%', 67, 4.3),
  createData(BNBImage1, 'BNB', '(BNB)', '$ 17.32', '+ 3.85%', 49, 3.9),
  createData(BNBImage1, 'BNB', '(BNB)', '$ 17.32', '+ 3.85%', 24, 4.0),
];

function TableSection(props) {
  const { classes } = props;
  const {
    LiveChart,
    statisticdata,
  } = props;
  
  return (
    <Fragment>
      <div className={classes.tableSection}>
        <TableContainer component={Paper} className={classes.table}>
          <Table aria-label="markets">
            <TableHead>
              <TableRow>
                <TableCell align="left" className={classes.tablenamecol}>NAME</TableCell>
                <TableCell align="cetner" className={classes.tablelastpricecol}>LAST PRICE</TableCell>
                <TableCell align="cetner">24H CHANGE</TableCell>
                <TableCell align="right">MARKETS</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {rows.map((row) => (
                <TableRow key={row.name}>
                  <TableCell scope="row" align="left" className={classes.tableicontext}>
                    <img src={row.icon} alt={row.name} className={classes.tableicon}/>
                    <strong className={classes.tableiconmaintext}>{row.name}</strong>
                    <strong className={classes.tableiconsubtext}>{row.subname}</strong>
                    </TableCell>
                  <TableCell align="left">{row.lastPrice}</TableCell>
                  <TableCell align="left" style={{color:`red`}}>{row.charge}</TableCell>
                  <TableCell align="right"><Chart LiveChart={LiveChart} data={statisticdata}/></TableCell>
                </TableRow>
              ))}
            </TableBody>
            <TableFooter>
              <TableRow key={`tablefooter`}>
                <TableCell colSpan={`4`} align={`center`} className={classes.tablemore}>                  
                    View more markets
                    <ChevronRightIcon className={classes.icon}/>                  
                </TableCell>
              </TableRow>
            </TableFooter>
          </Table>
        </TableContainer>
      </div>
    </Fragment>
  );
}

TableSection.propTypes = {
  LiveChart: PropTypes.elementType,
  statisticdata: PropTypes.object.isRequired,
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(TableSection)
);
