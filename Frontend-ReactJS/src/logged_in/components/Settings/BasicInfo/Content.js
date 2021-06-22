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
    background: `url("${landingImage}") center center no-repeat`,
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
    height:`20px`, 
    width:`100%`
  }, 
  content_linkspan:{
    border:`groove`, 
    borderColor:`red`, 
    borderWidth:`1px`, 
    borderRadius:`20px`, 
    width:`fit-content`, 
    paddingLeft:`0.5vw`, 
    paddingRight:`0.5vw`, 
    marginLeft:`1vw`
  },
  content_verifyicon:{
    paddingTop:`12px`, 
    color:`red`
  },
  content_linktext:{
    marginLeft:`0.5vw`, 
    color:`white`, 
    fontWeight:`normal`, 
    fontSize:`1rem`
  },
  content_linkright:{
    paddingTop:`12px`, 
    marginLeft:`0.5vw`, 
    color:`white`
  },
  content_avatar:{
    height:`4vw`, 
    width:`4vw`, 
    borderRadius:`100px`, 
    border:`groove`, 
    borderColor:`red`, 
    borderWidth:`2px`, 
    backgroundColor:`white`, 
    color:`black`, 
    padding:`1vw`
  },
  content_name:{
    color:`white`, 
    fontWeight:`normal`, 
    fontSize:`1.2rem`
  },
  content_id:{
    marginLeft:`1vw`, 
    color:`gray`, 
    fontWeight:`normal`, 
    fontSize:`1rem`
  },
  content_diamond:{
    marginLeft:`1vw`, 
    color:`red`, 
    paddingTop:`5px`
  },
  content_diamondtext:{
    marginLeft:`0.1vw`, 
    color:`red`, 
    fontWeight:`normal`, 
    fontSize:`1.1rem`
  },
  content_vip:{
    marginLeft:`0.5vw`, 
    color:`white`, 
    fontWeight:`normal`, 
    fontSize:`1.2rem`
  },
  content_more:{
    marginLeft:`0.5vw`, 
    color:`red`, 
    fontWeight:`normal`
  },
  content_login:{
    marginLeft:`4.7vw`, 
    color:`gray`, 
    fontWeight:`normal`, 
    fontSize:`0.9rem`
  },
  content_ip:{
    marginLeft:`2vw`, 
    color:`gray`, 
    fontWeight:`normal`, 
    fontSize:`0.9rem`
  },
  content_id_pan:{
    background: `url("${IdImage}") left no-repeat`,
    padding: theme.spacing(2),
    textAlign: 'left',
    color: theme.palette.text.secondary,
  },
  content_add_pan:{
    background: `url("${AddImage}") left no-repeat`,    
    padding: theme.spacing(2),
    textAlign: 'left',
    color: theme.palette.text.secondary,
  },
  content_with_pan:{
    background: `url("${WithImage}") left no-repeat`,
    padding: theme.spacing(2),
    textAlign: 'left',
    color: theme.palette.text.secondary,
  },
  content_pan_title:{
    color:`black`, 
    fontSize:`0.8rem`
  },
  content_pan_subtext:{
    color:`black`, 
    fontSize:`0.6rem`
  },
  content_pan_detail:{
    color:`gray`, 
    fontSize:`0.8rem`
  },
  content_pan_right:{
    backgroundColor:`gray`, 
    color:`white`, 
    borderRadius:`100px`
  },
  content_add_subpan:{
    marginLeft:`20px`, 
    marginTop:`1.5vh`
  },
  content_verifybutton:{
    width:`30%`, 
    marginTop:`1vh`, 
    marginLeft:`1vw`
  },
  content_addbutton:{
    width:`30%`, 
    marginTop:`2.5vh`, 
    marginLeft:`1vw`
  },
  content_withbutton:{
    width:`60%`, 
    marginTop:`4.5vh`, 
    marginLeft:`1vw`
  },
});

function Content(props) {
    const { classes } = props;  
    return (      
      <Fragment>
        <div key={"settings-basicinfo"} className={classes.landingBackgroundImage} >
          <div className={classes.top}>            
            Basic Info
            <span className={classes.content_linkspan}>
              <VerifiedUserIcon className={classes.content_verifyicon}/>
              <strong className={classes.content_linktext}>Protecting Personal Information</strong>
              <ChevronRightIcon className={classes.content_linkright}/>
            </span>
            <br/><br/>
            <span className={classes.content_avatar}>
              AA
            </span>
            <span style={{marginLeft:`1vw`}}>
              <strong className={classes.content_name}>Atul Awasthi</strong>
              <strong className={classes.content_id}>User ID: 44305385</strong>
              <LocalBarOutlinedIcon className={classes.content_diamond}/>
              <strong className={classes.content_diamondtext}>VIP0</strong>
              <strong className={classes.content_vip}>Maker: 0.075% Taker: 0.075%</strong>
              <a href="#" className={classes.content_more}>Learn more</a>
              <br/>
              <strong className={classes.content_login}>Last login time 2020 08 08 08:26L16</strong>
              <strong className={classes.content_ip}>IP: 162.120.200.51</strong>
            </span>
          </div>      
        </div>
        
        <div className={classes.root}>
          <Grid container spacing={3} style={{marginTop:`4vh`}}>
            <Grid item xs={4}>
              <Paper className={classes.content_id_pan}>
                <Grid container spacing={2}>
                  <Grid item xs={4} style={{marginLeft:`20px`}}>                    
                    <strong className={classes.content_pan_title}>
                      Identity Verification
                    </strong>        
                  </Grid>
                  <Grid item xs={5} style={{marginLeft:`1vw`}}>
                    <strong className={classes.content_pan_detail}>
                      Switch to Enterprise account
                    </strong>        
                  </Grid>
                  <Grid item xs={1}>
                    <ChevronRightIcon className={classes.content_pan_right}/>       
                  </Grid>                  
                  <Divider variant="middle" />
                  <Grid item xs={12} style={{marginLeft:`20px`}}>                    
                    <strong className={classes.content_pan_title}>
                      Personal details<br/><br/>
                      Why verify your identity?<br/>
                      <strong className={classes.content_pan_subtext}>
                        - To increase your withdrawal limit to 100 BTC<br/>
                        - To increase deposit limits for selected local currencies
                      </strong>
                    </strong>        
                  </Grid>
                  <Grid item xs={6} sm container>
                    <div className={classes.content_verifybutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Verify</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
            <Grid item xs={4}>
              <Paper className={classes.content_add_pan}>
                <Grid container spacing={2}>
                  <Grid item xs={4} style={{marginLeft:`20px`}}>                    
                    <strong className={classes.content_pan_title}>
                      Additional Verification
                    </strong>        
                  </Grid>               
                  <Divider variant="middle" />
                  <Grid item xs={12} className={classes.content_add_subpan}>                    
                    <strong className={classes.content_pan_title}>
                      Address verification<br/><br/>
                      Why include your residential address?<br/>
                      <strong className={classes.content_pan_subtext}>
                        - Further increase deposit limits for some flat channels<br/>
                      </strong>
                    </strong>        
                  </Grid>
                  <Grid item xs={6} sm container>
                    <div className={classes.content_addbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Verify</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
            <Grid item xs={4}>
              <Paper className={classes.content_with_pan}>
                <Grid container spacing={2}>
                  <Grid item xs={4} style={{marginLeft:`20px`}}>                    
                    <strong className={classes.content_pan_title}>
                      Withdrawal Limits
                    </strong>        
                  </Grid>              
                  <Divider variant="middle" />
                  <Grid item xs={12} className={classes.content_add_subpan}>                    
                    <strong className={classes.content_pan_title}>
                      2 BTC<br/><br/>
                      <strong className={classes.content_pan_subtext}>
                        - Withdraw up to 2 BTC within 24 hours<br/>
                      </strong>
                    </strong>        
                  </Grid>
                  <Grid item xs={6} sm container>
                    <div className={classes.content_withbutton}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Upgrade to higher limit</Button> 
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
  