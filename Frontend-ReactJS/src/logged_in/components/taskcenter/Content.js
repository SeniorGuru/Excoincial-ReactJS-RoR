import React, {Fragment } from "react";
import PropTypes from "prop-types";
import TurnedInNotSharpIcon from '@material-ui/icons/TurnedInNotSharp';
import ImportContactsSharpIcon from '@material-ui/icons/ImportContactsSharp';
import AttachMoneyIcon from '@material-ui/icons/AttachMoney';
import ShutterSpeedIcon from '@material-ui/icons/ShutterSpeed';

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
    color:`white`
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
  content_blacktext:{
    color:`black`
  },
  content_blacksubtext:{
    color:`black`, 
    marginBottom:`20px`
  },
  content_button:{
    width:`100%`, 
    marginTop:`4vh`
  },
  content_grid:{
    marginLeft:`20px`
  },
  content_issue:{
    fontWeight:'normal', 
    color:'gray'
  },
  content_giftImage:{
    background: `url("${giftImage}") right no-repeat`
  },
  content_newsImage:{
    background: `url("${newsImage}") right no-repeat`
  },
  content_spotImage:{
    background: `url("${spotImage}") right no-repeat`
  },
  content_depositImage:{
    background: `url("${depositImage}") right no-repeat`
  },
});

function Content(props) {
    const { classes } = props;  
    return (      
      <Fragment>
        <div key={"taskcenter-content"} className={classes.landingBackgroundImage} >
          <div className={classes.top}>            
            Task Center<br/><br/>
            <Button color="secondary" className={classes.top_button}>Beginner tasks</Button>
            <Button className={classes.top_button} disabled>Regular tasks</Button>
          </div>           
        </div>
        
        <div className={classes.root}>
          <Grid container spacing={5}>
            <Grid item xs>              
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={10}>
                    <h3 className={classes.content_blacktext}>Completed Tasks (1/6)</h3>
                    <LinearProgress variant="determinate" value={20} className={classes.progress}/>
                    <div className={classes.content_blacktext}>Complete beginner tasks to get a beginner gift pack</div>                    
                  </Grid>
                  <Grid item xs={12} sm container>
                    <Button variant="contained" color="primary" className={classes.progress_button}>Beginner Gift Pack</Button>  
                  </Grid>
                </Grid>       
              </Paper>
            </Grid>
          </Grid>
          <Grid container spacing={3} style={{marginTop:`20px`}}>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
                <Grid container spacing={2}>
                  <Grid item xs={1} className={classes.content_grid}>
                    <div className={classes.box_icon}>
                      <TurnedInNotSharpIcon/>
                    </div>                      
                  </Grid>
                  <Grid item xs={8} className={classes.content_grid}>
                    <h3 className={classes.content_blacktext}>Beginner Gift Pack</h3>
                    <div className={classes.content_blacksubtext}>Complete personal identity verification</div>                    
                  </Grid>
                  <Grid item xs={2} sm container className={classes.content_giftImage}>
                    <div className={classes.content_button}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Complete</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
              <Grid container spacing={2}>
                  <Grid item xs={1} className={classes.content_grid}>
                    <div className={classes.box_icon} style={{backgroundColor:`yellow`}}>
                      <ImportContactsSharpIcon/>
                    </div>                      
                  </Grid>
                  <Grid item xs={8} className={classes.content_grid}>
                    <h3 className={classes.content_blacktext}>Watch a beginner tutorial</h3>
                    <div className={classes.content_blacksubtext}>Learn how to buy digital currency</div>                    
                  </Grid>
                  <Grid item xs={2} sm container>
                    <div className={classes.content_button}>
                      <Button variant="contained" color="primary"  className={classes.box_button}>Complete</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
          </Grid>
          <Grid container spacing={2}>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
              <Grid container spacing={2}>
                  <Grid item xs={1} className={classes.content_grid}>
                    <div className={classes.box_icon} style={{backgroundColor:`yellow`}}>
                      <ImportContactsSharpIcon/>
                    </div>                      
                  </Grid>
                  <Grid item xs={8} className={classes.content_grid}>
                    <h3 className={classes.content_blacktext}>Read any piece of news</h3>
                    <div className={classes.content_blacksubtext}>Learn more about industry trends</div>                    
                  </Grid>
                  <Grid item xs={2} sm container className={classes.content_newsImage}>
                    <div className={classes.content_button}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Complete</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
              <Grid container spacing={2}>
                  <Grid item xs={1} className={classes.content_grid}>
                    <div className={classes.box_icon} style={{backgroundColor:`brown`}}>
                      <AttachMoneyIcon/>
                    </div>                      
                  </Grid>
                  <Grid item xs={8} className={classes.content_grid}>
                    <h3 className={classes.content_blacktext}>Complete any deposit</h3>
                    <div className={classes.content_blacksubtext}>Deposit flat or digital currency into your personal account</div>                    
                  </Grid>   
                  <Grid item xs={2} sm container className={classes.content_depositImage}>
                    <div className={classes.content_button}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Complete</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
          </Grid>
          <Grid container spacing={2}>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
              <Grid container spacing={2}>
                  <Grid item xs={1} className={classes.content_grid}>
                    <div className={classes.box_icon} style={{backgroundColor:`green`}}>
                      <ShutterSpeedIcon/>
                    </div>                      
                  </Grid>
                  <Grid item xs={8} className={classes.content_grid}>
                    <h3 className={classes.content_blacktext}>Complete any spot trade</h3>
                    <div className={classes.content_blacksubtext}>Make a trade using any currency pair</div>                    
                  </Grid>             
                  <Grid item xs={2} sm container className={classes.content_spotImage}>
                    <div className={classes.content_button}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Complete</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
            <Grid item xs={6}>
              <Paper className={classes.paper}>
              <Grid container spacing={2}>
                  <Grid item xs={1} className={classes.content_grid}>
                    <div className={classes.box_icon}>
                      <TurnedInNotSharpIcon/>
                    </div>                      
                  </Grid>
                  <Grid item xs={8} className={classes.content_grid}>
                    <h3 className={classes.content_blacktext}>Complete 2FA</h3>
                    <div className={classes.content_blacksubtext}>Enable 2FA on your account</div>                    
                  </Grid>
                  <Grid item xs={2} sm container  className={classes.content_giftImage}>
                    <div className={classes.content_button}>
                      <Button variant="contained" color="primary" className={classes.box_button}>Complete</Button> 
                    </div>                     
                  </Grid>
                </Grid>    
              </Paper>
            </Grid>
          </Grid>
          <div style={{paddingTop:'2vh'}}>
            <a href="#" className={classes.content_issue}>Any issues?</a>
          </div>
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
  