import React, {Fragment } from "react";
import PropTypes from "prop-types";
import TurnedInNotSharpIcon from '@material-ui/icons/TurnedInNotSharp';
import ImportContactsSharpIcon from '@material-ui/icons/ImportContactsSharp';
import AttachMoneyIcon from '@material-ui/icons/AttachMoney';
import ShutterSpeedIcon from '@material-ui/icons/ShutterSpeed';
import VerifiedUserIcon from '@material-ui/icons/VerifiedUser';
import ChevronRightIcon from '@material-ui/icons/ChevronRight';
import LocalBarOutlinedIcon from '@material-ui/icons/LocalBarOutlined';

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
} from "@material-ui/core";
import landingImage from "../../../../assets/images/Task center/Main-bg.png";
import IdImage from "../../../../assets/images/Setting BasicInfo/additional-varification.png";
import AddImage from "../../../../assets/images/Setting BasicInfo/identiniy-verification.png";
import WithImage from "../../../../assets/images/Setting BasicInfo/withdrawlsLimit.png";
import { fontSize } from "@material-ui/system";

const styles = theme => ({  
  landingBackgroundImage: {
    marginTop:-60,
    marginLeft:-180,
    display: `flex`,
    justifyContent: `left`,
    width:`100vw`,
    height:200,
  },
  Content: {
    display: `flex`,
    justifyContent: `left`,
    paddingTop:50,
    paddingLeft:260,
    color:`white`,
    fontSize:`2.5rem`,
  },   
  root: {
    flexGrow: 1,
    paddingLeft:60,
    width:`79vw`,
    marginTop:-50,
  },
  paper: {
    padding: theme.spacing(2),
    textAlign: 'left',
    color: theme.palette.text.secondary,
  },
  top: {
    fontSize:`1.1rem`,
    fontWeight:`bold`,
    paddingTop:40,
    paddingLeft:250,
    color:`white`,
    width:`100%`,
  },
  top_button:{
    color:`white`,
    width:`200px`, 
    marginLeft:0, 
    marginRight:`20px`, 
    border:`none`
  },
  progress:{
    marginBottom:20, 
    width:`100%`, 
    height:`10px`, 
    borderRadius:`18px`
  },
  progress_button:{
    color:`white`, 
    border:`none`, 
    height:`20px`, 
    width:`100%`, 
    marginTop:`23%`
  },
  box_icon:{
    marginTop:`25px`, 
    borderRadius:`50px`, 
    backgroundColor:`blue`, 
    height:`40px`, 
    width:`40px`, 
    color:`white`, 
    paddingLeft:`8px`, 
    paddingTop:`7px`
  },
  box_button:{
    color:`white`, 
    border:`none`, 
    height:`6vh`, 
    width:`100%`,
    marginBottom:`3vh`
  }, 
  content_subgrid:{
    marginLeft:`20px`
  },
  content_input:{
    width:`80%`, 
    marginTop:`1vh`, 
    marginLeft:`1.2vw`, 
    height:`6vh`, 
    borderRadius:`50px`, 
    marginBottom:`5vh`, 
    marginTop:`3vh`, 
    paddingLeft:`1vw`
  },
  content_comment:{
    color:`black`, 
    fontSize:`0.8rem`, 
    textAlign:`center`, 
    float:`left`, 
    marginLeft:`3.5vw`
  },
  content_header:{
    color:`black`, 
    fontSize:`1.2rem`
  },
  content_link:{
    color:`red`, 
    fontSize:`0.8rem`
  },
  content_right:{
    backgroundColor:`gray`, 
    color:`white`, 
    borderRadius:`100px`
  },
  content_buttondiv:{
    width:`80%`, 
    marginTop:`1vh`, 
    marginLeft:`1vw`
  },
});

function Content(props) {
    const { classes } = props;  
    return (      
      <Fragment>        
        <div className={classes.root}>
          <Grid container spacing={3} style={{marginTop:`20vh`}}>
            <Grid item xs={5} style={{marginLeft:`22vw`}}>
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={6} className={classes.content_subgrid}>                    
                    <strong className={classes.content_header}>
                      Create API
                    </strong>        
                  </Grid>
                  <Grid item xs={4} style={{marginLeft:`1vw`}}>
                    <a href="#" className={classes.content_link}>
                      View API documentation
                    </a>        
                  </Grid>
                  <Grid item xs={1}>
                    <ChevronRightIcon className={classes.content_right}/>       
                  </Grid>                  
                  <Divider variant="middle" />
                  <Grid item xs={12} className={classes.content_subgrid}>                    
                    <strong className={classes.content_comment}>
                    Creating an API private key provides access to markets and real-time <br/>trading services on Binance via a third-party site or application.
                    </strong>        
                  </Grid>
                  <Grid item xs={8} sm container style={{marginLeft:`2vw`}}>
                    <input className={classes.content_input} placeholder={'Give the API key a label'}>
                    </input>
                    <div className={classes.content_buttondiv}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Create</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>            
          </Grid>         
        </div>
      </Fragment>  
    );
}


Content.propTypes = {
    classes: PropTypes.object,
    width: PropTypes.string,
    theme: PropTypes.object
  };
  
  export default withWidth()(
    withStyles(styles, { withTheme: true })(Content)
  );
  