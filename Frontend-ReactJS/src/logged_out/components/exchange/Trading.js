import React, {useState} from "react";
import PropTypes from "prop-types";
import MaterialTable from 'material-table';
import TradingViewWidget from "react-tradingview-widget";
import {
  withStyles,
  makeStyles,
  withWidth,
  Typography,
  Button,
  Box,
  Grid,
  Paper,
  LinearProgress,
  Divider,
  Tabs,
  Tab,
  FormControl,
  Select
} from "@material-ui/core";

const styles = theme => ({  
  Content: {
    display: `flex`,
    justifyContent: `left`,
    // paddingTop:50,
    paddingLeft:260,
    color:`white`,
    fontSize:`2.5rem`,
  },   
  root: {
    marginLeft:`10vw`,
    width:`80vw`,
    marginTop:`4vh`,
    marginBottom:`4vh`
  },
  paper: {
    padding: theme.spacing(2),
    textAlign: 'left',
    color: theme.palette.text.secondary,
  },
  materialTable: {    
    backgroundColor:`gray`,
    overflowX: `scroll`,
    width: '100%',
  },
  tabletab:{
    fontSize:`12px`,
  },
  formControl: {
    margin: theme.spacing(1),
    paddingLeft: 10,
    height:'100%',
    width:`100%`,
    marginTop:12,
    marginLeft:0,
  },
  formselect:{
    height:`100%`,
    fontSize:`0.8rem`,
    paddingLeft:5,
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
});

function Trading(props) {
  const { symbol , classes} = props;  
  const [ tabIndex, setTabIndex] = useState(0);
  const [ selectIndex, setSelectIndex] = useState(0);  
  const [ marketData, setMarketData] = useState([]);
  const [state, setState] = React.useState({
    name: 'dec-2',
    name1: 'change',
  });
  const handleChange = (event, newValue) => {
    setTabIndex(newValue);
  };
  const handleChange1 = (event, newValue) => {
    setSelectIndex(newValue);
  };

  return (
    <div className={classes.root}>
      <Grid container spacing={1}>
        <Grid item xs={9}>
          <Paper>
            <Grid container>
              <Grid item xs={12} style={{marginLeft:`10px`}}>   
                <Grid container spacing={1}>               
                  <Grid item xs={2} style={{paddingTop:`10px`, paddingBottom:`10px`}}>                    
                    <strong >BTC <weak style={{color:`gray`, fontWeight:`weak`, fontSize:`12px`}}>/ USDT</weak></strong>
                    <br/>
                    <strong style={{color:`dark`, fontWeight:`weak`, fontSize:`12px`}}>Bitcoin</strong>
                  </Grid>                                
                  <Grid item xs={2} style={{paddingTop:`10px`, paddingBottom:`10px`}}> 
                    <strong style={{color:`gray`, fontWeight:`weak`, fontSize:`12px`}}>Last Price</strong>
                    <br/>
                    <strong style={{color:`red`}}>
                      9,155.50 <weak style={{color:`black`, fontWeight:`weak`, fontSize:`12px`}}>64,800.87</weak>
                    </strong>
                  </Grid>                                
                  <Grid item xs={2} style={{paddingTop:`10px`, paddingBottom:`10px`}}>                    
                    <strong style={{color:`gray`, fontWeight:`weak`, fontSize:`12px`}}>Last Price</strong>
                    <br/>
                    <strong style={{color:`red`}}>9,155.50 -0.24%</strong>
                  </Grid>                                
                  <Grid item xs={2} style={{paddingTop:`10px`, paddingBottom:`10px`}}>
                    <strong style={{color:`gray`, fontWeight:`weak`, fontSize:`12px`}}>Last Price</strong>
                    <br/>
                    <strong style={{color:`black`, fontWeight:`weak`, fontSize:`12px`}}>0,128.00</strong>
                  </Grid>                                
                  <Grid item xs={2} style={{paddingTop:`10px`, paddingBottom:`10px`}}>         
                    <strong style={{color:`gray`, fontWeight:`weak`, fontSize:`12px`}}>24h Low</strong>
                    <br/>
                    <strong style={{color:`black`, fontWeight:`weak`, fontSize:`12px`}}>9,045.50</strong>  
                  </Grid>                                
                  <Grid item xs={2} style={{paddingTop:`10px`, paddingBottom:`10px`}}>      
                    <strong style={{color:`gray`, fontWeight:`weak`, fontSize:`12px`}}>24h Volume</strong>
                    <br/>
                    <strong style={{color:`black`, fontWeight:`weak`, fontSize:`12px`}}>331,746,884.50 USDT</strong>              
                  </Grid>          
                </Grid>
              </Grid>              
            </Grid>                
          </Paper>
          <Paper style={{marginTop:`2vh`}}>
            <Grid container spacing={2}>
              <Grid item xs={4}>       
                <Grid Container>
                  {/* <paper> */}
                    <Grid item xs={12}>
                      <MaterialTable
                        // icons={tableIcons}
                        className={classes.materialTable}
                        title={
                          <Tabs
                            value={tabIndex}
                            indicatorColor="primary"
                            textColor="primary"
                            onChange={handleChange}
                          >
                            <Tab label="A" className={classes.tabletab} />
                            <Tab label="B" className={classes.tabletab} />
                            <Tab label="C" className={classes.tabletab} />
                            <Tab label="Groups" className={classes.tabletab} />                                      
                            <FormControl className={classes.formControl}>
                              <Select
                                native
                                value={state.name}
                                onChange={handleChange}
                                className={classes.formSelect}
                                inputProps={{
                                  name: '2 decimal',
                                  id: 'dec-2',
                                }}
                                className={classes.formselect}
                              >
                                <option value={'dec2'}>2 decimal</option>
                                <option value={'dec1'}>1 decimal</option>
                                {/* <option value={20}>Twenty</option>
                                <option value={30}>Thirty</option> */}
                              </Select>
                            </FormControl>
                          </Tabs>}
                        options={{
                          search: false,
                          tableLayout: `auto`,
                          // pageSize: 20,
                          // pageSizeOptions: [20,50,100,200]
                        }}
                        columns={[
                          {title: 'Price(BTC)', field: 'priceBTC', headerStyle: {textAlign: `left`}},
                          {title: 'Amount(ETH)', field: 'amountETH', headerStyle: {textAlign: `left`}},
                          {title: 'Total', field: 'total', headerStyle: {textAlign: `right`}},
                        ]}
                        data = {marketData}
                      />
                      <MaterialTable
                        // icons={tableIcons}
                        className={classes.materialTable}
                        title={
                          <Tabs
                            value={tabIndex}
                            indicatorColor="primary"
                            textColor="primary"
                            onChange={handleChange}
                          >
                            <Tab label="A" className={classes.tabletab} />
                            <Tab label="B" className={classes.tabletab} />
                            <Tab label="C" className={classes.tabletab} />
                            <Tab label="Groups" className={classes.tabletab} />                                      
                            <FormControl className={classes.formControl}>
                              <Select
                                native
                                value={state.name}
                                onChange={handleChange}
                                className={classes.formSelect}
                                inputProps={{
                                  name: '2 decimal',
                                  id: 'dec-2',
                                }}
                                className={classes.formselect}
                              >
                                <option value={'dec2'}>2 decimal</option>
                                <option value={'dec1'}>1 decimal</option>
                                {/* <option value={20}>Twenty</option>
                                <option value={30}>Thirty</option> */}
                              </Select>
                            </FormControl>
                          </Tabs>}
                        options={{
                          search: false,
                          tableLayout: `auto`,
                          // pageSize: 20,
                          // pageSizeOptions: [20,50,100,200]
                        }}
                        columns={[
                          {title: 'Price(BTC)', field: 'priceBTC', headerStyle: {textAlign: `left`}},
                          {title: 'Amount(ETH)', field: 'amountETH', headerStyle: {textAlign: `left`}},
                          {title: 'Total', field: 'total', headerStyle: {textAlign: `right`}},
                        ]}
                        data = {marketData}
                      />
                    </Grid> 
                  {/* </paper> */}
                </Grid>         
              </Grid>           
              <Grid item xs={8} style={{minHeight:`100vh`}}>     
                <Grid Container>
                  <paper>
                    <Grid item xs={12} style={{minHeight:`100%`}}>

                    </Grid> 
                  </paper>
                </Grid>    
              </Grid>              
            </Grid>                
          </Paper>
        </Grid>
        <Grid item xs={3}>
          <Paper>
            <Grid container spacing={2}>
              <Grid item xs={12} style={{marginLeft:`10px`}}>                    
                <MaterialTable
                  // icons={tableIcons}
                  className={classes.materialTable}
                  title={
                    <Tabs
                      value={tabIndex}
                      indicatorColor="primary"
                      textColor="primary"
                      onChange={handleChange}
                    >
                      <Tab label="Change" className={classes.tabletab} />
                      <Tab label="Volume" className={classes.tabletab} />  
                    </Tabs>}
                  options={{
                    search: true,
                    tableLayout: `auto`,
                  }}
                  columns={[
                    {title: 'Pair', field: 'priceBTC', headerStyle: {textAlign: `left`}},
                    {title: 'Price', field: 'amountETH', headerStyle: {textAlign: `right`}},
                    {title: 'Change', field: 'total', headerStyle: {textAlign: `right`}},
                  ]}
                  data = {marketData}
                />  
                <MaterialTable
                  // icons={tableIcons}
                  className={classes.materialTable}
                  title={
                    <Tabs
                      value={tabIndex}
                      indicatorColor="primary"
                      textColor="primary"
                      onChange={handleChange}
                    >
                      <Tab label="Trade History" className={classes.tabletab} />                                                        
                    </Tabs>}
                  options={{
                    search: false,
                    tableLayout: `auto`,
                  }}
                  columns={[
                    {title: 'Pair', field: 'priceBTC', headerStyle: {textAlign: `left`}},
                    {title: 'Price', field: 'amountETH', headerStyle: {textAlign: `right`}},
                    {title: 'Change', field: 'total', headerStyle: {textAlign: `right`}},
                  ]}
                  data = {marketData}
                />     
              </Grid>              
            </Grid>    
          </Paper>
        </Grid>
      </Grid>         
    </div>
      // <TradingViewWidget
      //   symbol={symbol}
      // />
  );
}
Trading.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object,
  symbol: PropTypes.string.isRequired
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(Trading)
);

