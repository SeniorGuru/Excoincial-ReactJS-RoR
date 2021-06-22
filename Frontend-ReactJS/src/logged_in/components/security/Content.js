import React, {Fragment } from "react";
import PropTypes from "prop-types";
import TurnedInNotSharpIcon from '@material-ui/icons/TurnedInNotSharp';
import ImportContactsSharpIcon from '@material-ui/icons/ImportContactsSharp';
import AttachMoneyIcon from '@material-ui/icons/AttachMoney';
import ShutterSpeedIcon from '@material-ui/icons/ShutterSpeed';
import CheckCircleIcon from '@material-ui/icons/CheckCircle';
import CancelIcon from '@material-ui/icons/Cancel';

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
import landingImage from "../../../assets/images/Task center/Main-bg.png";
import giftImage from "../../../assets/images/Task center/2FA.png";
import newsImage from "../../../assets/images/Task center/read-icon.png";
import spotImage from "../../../assets/images/Task center/spottrade.png";
import depositImage from "../../../assets/images/Task center/deposit.png";
import completeImage from "../../../assets/images/Task center/gift-pack-icon.png";
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
    marginLeft:`20px`
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
  box_button:{
    width:`5vw`
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
    marginTop:`2.5vh`, 
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
        <div key={"taskcenter-content"} className={classes.landingBackgroundImage} >
          <div className={classes.top}>            
            Increase your account security ( 1 / 4 )<br/><br/>
            <div>
              <CheckCircleIcon className={classes.check}/>
              <a href="#" className={classes.link}>Enable 2FA</a>
              <CancelIcon className={classes.close}/>
              <a href="#" className={classes.link}>Verify</a>
              <CancelIcon className={classes.close}/>
              <a href="#" className={classes.link}>Enable Anti phishing Code</a>
              <CancelIcon className={classes.close}/>
              <a href="#" className={classes.link}>Turn on withdrawal whitelist</a>
            </div>      
          </div>           
        </div>        
        <div className={classes.root}>
          <Grid container spacing={3} style={{marginTop:`20px`}}>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={12} className={classes.content_box}>
                    <strong className={classes.content_header}>2FA</strong>
                  </Grid>
                  <Grid item xs={9} className={classes.content_box}>
                    <h3>
                      <strong className={classes.content_subheader}>Security Key</strong>
                      <normal className={classes.content_commit}>Recommend: YubiKey</normal>
                    </h3>
                    <a href="" className={classes.content_asklink}>What is a Security Key?</a>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_head_button}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Setup</Button> 
                    </div>                     
                  </Grid>
                  <Grid item xs={3} className={classes.content_box}>
                    <h4>
                      <strong style={{color:`gray`, fontWeight:`normal`}}>Protected Actions</strong>
                      <br/>
                      <strong style={{color:`black`, fontWeight:`normal`}}>Withdraw & API</strong>
                    </h4>
                  </Grid>
                  <Grid item xs={2} style={{marginTop:`15px`}}>
                    <FormControlLabel control={<IOSSwitch checked={true} name="checkedA" />} label=""/>
                    {/* <Divider orientation="vertical" flexItem /> */}
                    <strong className={classes.switch_label}>Login</strong>
                  </Grid>  
                  <Grid item xs={4} className={classes.content_subbox}>
                    <FormControlLabel control={<IOSSwitch name="checkedB" />} label=""/>
                    {/* <Divider orientation="vertical" flexItem /> */}
                    <strong className={classes.switch_label}>Reset Password</strong>
                  </Grid>        
                  <Grid item xs={1} style={{marginLeft:`25px`, marginTop:`15px`}}>
                    <FormControlLabel control={<IOSSwitch name="checkedB" />} label=""/>
                  </Grid>                 
                </Grid>
                <Divider variant="middle" />
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_box}>
                    <h3 style={{color:`black`}}>Google Authentication</h3>
                    <div style={{color:`black`, marginBottom:`10px`}}>
                     Used for withdrawals and security modifications
                    </div>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>ON</Button> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_box}>
                    <h3 style={{color:`black`}}>SMS Authentication</h3>
                    <div style={{color:`black`, marginBottom:`10px`}}>
                     Used for withdrawals and security modifications
                    </div>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button} disabled>DISABLE</Button> 
                    </div>                     
                  </Grid>
                </Grid>  
                <Divider variant="middle" />
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_box}>
                    <h3 style={{color:`black`}}>E-mail verification</h3>
                    <div style={{color:`black`, marginBottom:`10px`}}>
                     Used for withdrwals and security modifications
                    </div>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>RESET</Button> 
                    </div>                     
                  </Grid>
                </Grid>  
              </Paper>
              <Paper style={{marginTop:`2vh`}}>
                <Grid container spacing={2}>
                  <Grid item xs={8} style={{marginLeft:`35px`}}>
                    <h3 style={{color:`black`, marginTop:`1.5vh`}}>Device Management</h3>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_bottombutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>MANAGE</Button> 
                    </div>                     
                  </Grid>
                </Grid>  
              </Paper>
              <Paper style={{marginTop:`2vh`}}>
                <Grid container spacing={2}>
                  <Grid item xs={8} style={{marginLeft:`35px`}}>
                    <h3 style={{color:`black`, marginTop:`1.5vh`}}>Login Password</h3>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_bottombutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>CHANGE</Button> 
                    </div>                     
                  </Grid>
                </Grid>  
              </Paper>
            </Grid>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_box}>
                    <h3 style={{color:`black`}}>Identity Verification</h3>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton} style={{marginTop:`1vh`}}>
                      <Button variant="contained" color="primary" className={classes.box_button}>VERIFY</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
                <Divider variant="middle" />
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_rightbox}>
                    <h3 style={{color:`black`}}>Address Management</h3>
                    <div style={{color:`black`, marginBottom:`20px`}}>
                      Address Management allows you to save and write memos for each of your withdrawal addresses.<br/>
                      The optional Whitelist function helps protect your funds by only allowing withdrawals to whitelisted addresses.<br/><br/>
                      <a href="" className={classes.content_whitelink}>Whitelist Off</a>
                      <FormControlLabel control={<IOSSwitch name="checkedA" />} label=""/>
                    </div>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>MANAGE</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
                <Divider variant="middle" />
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_rightbox}>
                    <h3 style={{color:`black`}}>Anti-phishing Code</h3>
                    <div style={{color:`black`, marginBottom:`20px`}}>
                     By setting up an Anti-Phishing Code, you will be able to tell if your notofication emails are coming from Binance or phishing attempts.
                    </div>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Enable</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
                <Divider variant="middle" />
                <Grid container spacing={2}>
                  <Grid item xs={9} className={classes.content_rightbox}>
                    <h3 style={{color:`black`}}>Account Activity</h3>
                    <div style={{color:`black`, marginBottom:`20px`}}>
                     Last login 2020-08-08 02:09:47 <br/>
                     Suspicious account activity?
                     <a href="#" className={classes.content_disablelink}>Disable account</a>
                    </div>
                  </Grid>
                  <Grid item xs={3} sm container>
                    <div className={classes.content_subbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button} style={{width:`5vw`}}>More</Button> 
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
  