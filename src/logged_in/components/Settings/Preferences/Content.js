import React, {Fragment } from "react";
import PropTypes from "prop-types";
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';

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
  Switch,
  FormGroup,
  FormControlLabel,
} from "@material-ui/core";
import landingImage from "../../../../assets/images/Task center/Main-bg.png";
import giftImage from "../../../../assets/images/Task center/2FA.png";
import newsImage from "../../../../assets/images/Task center/read-icon.png";
import spotImage from "../../../../assets/images/Task center/spottrade.png";
import depositImage from "../../../../assets/images/Task center/deposit.png";
import completeImage from "../../../../assets/images/Task center/gift-pack-icon.png";
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
  link: {
    color:`gray`, 
    marginLeft:`10px`, 
    fontWeight:`normal`
  },
  check:{
    color:`green`
  },
  close:{
    color:`red`, 
    marginLeft:`30px`
  },
  top:{
    fontSize:`1.1rem`,
    fontWeight:`bold`,
    paddingTop:40,
    paddingLeft:250,
    color:`black`
  },
  content_header:{
    color:`black`, 
    fontSize:'1.3rem', 
    fontWeight:'bold'
  },
  content_box:{
    marginLeft:`20px`,
    marginBottom:`1vh`
  },
  content_subheader:{
    color:`black`
  },
  content_commit:{
    color:`gray`, 
    marginLeft:`10px`, 
    fontWeight:`normal`
  },
  content_asklink:{
    color:`black`, 
    fontWeight:`normal`, 
    marginRight:'20px'
  },    
  content_head_button:{
    width:`100%`, 
    marginTop:`4vh`, 
    float:`right`
  },
  box_select:{
    width:`7vw`,
    marginTop:`1vh`
  },
  switch_label:{
    color:`black`, 
    fontWeight:`normal`
  },
  content_subbox:{
    marginLeft:`25px`, 
    marginTop:`15px`
  },
  content_subbutton:{
    width:`100%`, 
    marginTop:`0.5vh`, 
    float:`right`
  },
  content_bottombutton:{
    width:`100%`, 
    marginTop:`1vh`, 
    float:`right`,
    marginLeft:`2vw`
  },
  content_disablelink:{
    color:`red`, 
    fontWeight:`normal`, 
    marginLeft:`5px`
  },
  content_whitelink:{
    color:`black`, 
    fontWeight:`normal`, 
    marginRight:'20px'
  },
  content_rightbox:{
    marginLeft:`20px`,
    marginTop:`2vh`
  },
  content_subpaper:{
    marginTop:`1vh`
  },
  content_subtitle:{
    color:`black`, 
    marginTop:`1.5vh`, 
    marginBottom:`0.5vh`
  },
  content_blacktext:{
    color:`black`
  },
  content_footertext:{
    marginLeft:`35px`, 
    marginBottom:`0.5vh`
  },
});

const IOSSwitch = withStyles((theme) => ({
  root: {
    width: 42,
    height: 26,
    padding: 0,
    margin: theme.spacing(1),
  },
  switchBase: {
    padding: 1,
    '&$checked': {
      transform: 'translateX(16px)',
      color: theme.palette.common.white,
      '& + $track': {
        backgroundColor: '#52d869',
        opacity: 1,
        border: 'none',
      },
    },
    '&$focusVisible $thumb': {
      color: '#52d869',
      border: '6px solid #fff',
    },
  },
  thumb: {
    width: 24,
    height: 24,
  },
  track: {
    borderRadius: 26 / 2,
    border: `1px solid ${theme.palette.grey[400]}`,
    backgroundColor: theme.palette.grey[50],
    opacity: 1,
    transition: theme.transitions.create(['background-color', 'border']),
  },
  checked: {},
  focusVisible: {},
}))(({ classes, ...props }) => {
  return (
    <Switch
      focusVisibleClassName={classes.focusVisible}
      disableRipple
      classes={{
        root: classes.root,
        switchBase: classes.switchBase,
        thumb: classes.thumb,
        track: classes.track,
        checked: classes.checked,
      }}
      {...props}
    />
  );
});


function Content(props) {
    const { classes } = props;  
    return (      
      <Fragment>    
        <div className={classes.root}>
          <h1 style={{paddingTop:`2vh`}}>Preferences</h1>
          <Grid container spacing={3} style={{marginTop:`20px`}}>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={12} className={classes.content_box}>
                    <strong className={classes.content_header}>Order Confirmation</strong>
                    <br/>
                    If the order reminder function is enabled, it will need to be reconfirmed every time an order is submitted.
                  </Grid>  
                </Grid>    
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>Limit Order</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>Market Order</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>Market Order</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
                    </div>                     
                  </Grid>
                </Grid>  
              </Paper>
              <Paper style={{marginTop:`2vh`}}>
                <Grid container spacing={2}>
                  <Grid item xs={7} className={classes.content_footertext}>
                    <h3 className={classes.content_subtitle}>Notification Language Settings</h3>
                    Set preferred notification language
                  </Grid>
                  <Grid item xs={2} sm container style={{marginLeft:`1vw`}}>
                    <div className={classes.content_bottombutton}>
                      <Button variant="contained" color="primary" className={classes.box_select}>
                        English
                        <ExpandMoreIcon style={{marginLeft:`0.5vw`}}/>
                      </Button> 
                    </div>                     
                  </Grid>
                </Grid>  
              </Paper>              
            </Grid>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={12} className={classes.content_box}>
                    <strong className={classes.content_header}>Notification Management</strong>
                    <br/>
                    Set preferred notification types.
                  </Grid>  
                </Grid>    
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>System Messagesr</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>Activities</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>Excoincial News</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2} className={classes.content_subpaper}>
                  <Grid item xs={10} className={classes.content_box}>
                    <h3 className={classes.content_blacktext}>Trade Notification</h3>
                  </Grid>
                  <Grid item xs={1} sm container>
                    <div className={classes.content_subbutton}>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/> 
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
  