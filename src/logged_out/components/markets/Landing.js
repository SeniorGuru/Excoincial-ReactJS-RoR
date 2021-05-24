import React, { Fragment } from "react";
import PropTypes from "prop-types";
import {
  withStyles,
  withWidth,
  Grid,
  Typography,
} from "@material-ui/core";
import landingImage from "../../../assets/images/Main-Home-page-banner.png";
import marketImage1 from "../../../assets/images/blue.png";
import marketImage2 from "../../../assets/images/red.png";
import buyImage from "../../../assets/images/icons/icon.png";


const styles = theme => ({
  landingBackgroundImage: {
    display: `flex`,
    justifyContent: `center`,
    background: `url("${landingImage}") center center no-repeat`,
    paddingTop: 200,
    paddingBottom: 100,
    [theme.breakpoints.down("md")]:{
        backgroundColor:'black',
        paddingBottom: '50px',
        paddingTop:'70px',
    },
    [theme.breakpoints.down("sm")]:{
        backgroundColor:'black',
        paddingBottom: '50px',
        paddingTop:'70px',
    }
  },
  bestSeller: {
    backgroundImage: `linear-gradient(to right, rgb(14,13,81) 25%, rgb(74,59,144) 50%, rgb(14,13,81) 75%)`,
    paddingTop: theme.spacing(3),
    paddingBottom: theme.spacing(3),
    
  },
  bestSellerItem: {
    color: theme.palette.background.default,
    display: `flex`,
    justifyContent: `center`,
  },
  transactions: {
    backgroundColor: theme.palette.background.default,
  },
  marketImageBlue:{
    background: `url("${marketImage1}") center center no-repeat`,
    backgroundSize: `100% 100%`,
    height: 250,
    paddingLeft: 20,
    marginLeft: 20,
    marginRight: 20,
  },
  marketImageRed:{
    background: `url("${marketImage2}") center center no-repeat`,
    backgroundSize: `100% 100%`,
    height: 250,
    paddingLeft: 20,
    marginLeft: 20,
    marginRight: 20,
  },
  pOrMBlue:{
    marginTop: 20,
    backgroundColor: `rgb(6,168,155)`,
    height: 45,
    padding: 8,
    marginRight:5,
    borderRadius: `25px 0 0 25px`,
  },
  pOrMRed:{
    marginTop: 20,
    backgroundColor: `rgb(222,13,44)`,
    height: 45,
    padding: 8,
    marginRight:5,
    borderRadius: `25px 0 0 25px`,
  },
  icon:{
    paddingLeft:'10px', 
    paddingRight:'10px',
    width:`30%`,
  },
  icontext:{
    fontSize:`1rem`,
    [theme.breakpoints.down('md')]:{
      paddingLeft:'10px'
    },
    [theme.breakpoints.down('sm')]:{
      paddingLeft:'10px'
    },
  },
  iconsubtext:{
    fontSize:`0.6rem`,
  },
  landingbottomtext:{
    color: theme.palette.background.default, 
    paddingTop: 20,
  },
});

function Landing(props) {
  const { classes, theme } = props;

  return (
    <Fragment>
      <div key={"market-landing-1"} className={classes.landingBackgroundImage} >
        <Grid container style={{justifyContent:'center'}}>
          <Grid item md={3} sm={12} className={classes.marketImageBlue}>
            <div style={{display:`flex`, justifyContent:`space-between`}}>
              <div key="market-landing-left-1">
                <Typography variant="h6" className={classes.landingbottomtext}>BNB/USDT</Typography>
                <div style={{display: `flex`, justifyContent: `left`}}>
                  <Typography variant="h6" style={{color: `rgb(0,230,212)`}}>16.2208</Typography>
                  <Typography variant="overline" style={{color: theme.palette.background.default}}>&nbsp;&nbsp;$ 16.21</Typography>
                </div>
                <Typography variant="overline" style={{color: theme.palette.background.default, paddingBottom: 200}}>Volume: 20,602,681.72 USDT</Typography>
              </div>
              <div className={classes.pOrMBlue}>
                <Typography variant="h6" style={{color: theme.palette.background.default}}>+ 0.45%</Typography>
              </div>
            </div>
          </Grid>
          <Grid item md={3} sm={12} className={classes.marketImageRed}>
            <div style={{display:`flex`, justifyContent:`space-between`}}>
              <div key="market-landing-left-1">
                <Typography variant="h6" className={classes.landingbottomtext}>BNB/USDT</Typography>
                <div style={{display: `flex`, justifyContent: `left`}}>
                  <Typography variant="h6" style={{color: `rgb(222,15,45)`}}>16.2208</Typography>
                  <Typography variant="overline" style={{color: theme.palette.background.default}}>&nbsp;&nbsp;$ 16.21</Typography>
                </div>
                <Typography variant="overline" style={{color: theme.palette.background.default, paddingBottom: 200}}>Volume: 20,602,681.72 USDT</Typography>
              </div>
              <div className={classes.pOrMRed}>
                <Typography variant="h6" style={{color: theme.palette.background.default}}>+ 0.45%</Typography>
              </div>
            </div>
          </Grid>
          <Grid item md={3} sm={12} className={classes.marketImageBlue}>
            <div style={{display:`flex`, justifyContent:`space-between`}}>
              <div key="market-landing-left-1">
                <Typography variant="h6" className={classes.landingbottomtext}>BNB/USDT</Typography>
                <div style={{display: `flex`, justifyContent: `left`}}>
                  <Typography variant="h6" style={{color: `rgb(0,230,212)`}}>16.2208</Typography>
                  <Typography variant="overline" style={{color: theme.palette.background.default}}>&nbsp;&nbsp;$ 16.21</Typography>
                </div>
                <Typography variant="overline" style={{color: theme.palette.background.default, paddingBottom: 200}}>Volume: 20,602,681.72 USDT</Typography>
              </div>
              <div className={classes.pOrMBlue}>
                <Typography variant="h6" style={{color: theme.palette.background.default}}>+ 0.45%</Typography>
              </div>
            </div>
          </Grid>
        </Grid>
      </div>
      <div key={"market-best-seller-1"} className={classes.bestSeller}>
        <Grid container>
          <Grid item lg={3} md={3} sm={6} xs={12} className={classes.bestSellerItem}>
            <Typography variant="h6" className={classes.icontext}>
              BUST/USDT
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;33517.1 BUSD
              <img src={buyImage} alt="Buy" className={classes.icon}/>
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;Large Buy 22:41:56
            </Typography>
          </Grid>
          <Grid item lg={3} md={3} sm={6} xs={12} className={classes.bestSellerItem}>
            <Typography variant="h6" className={classes.icontext}>
              BUST/USDT
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;33517.1 BUSD
              <img src={buyImage} alt="Buy" className={classes.icon}/>
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;Large Buy 22:41:56
            </Typography>
          </Grid>
          <Grid item lg={3} md={3} sm={6} xs={12} className={classes.bestSellerItem}>
            <Typography variant="h6" className={classes.icontext}>
              BUST/USDT
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;33517.1 BUSD
              <img src={buyImage} alt="Buy" className={classes.icon}/>
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;Large Buy 22:41:56
            </Typography>
          </Grid>
          <Grid item lg={3} md={3} sm={6} xs={12} className={classes.bestSellerItem}>
            <Typography variant="h6" className={classes.icontext}>
              BUST/USDT
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;33517.1 BUSD
              <img src={buyImage} alt="Buy" className={classes.icon}/>
            </Typography>
            <Typography variant="overline" className={classes.iconsubtext}>
              &nbsp;Large Buy 22:41:56
            </Typography>
          </Grid>
        </Grid>
      </div>
    </Fragment>
  );
}

Landing.propTypes = {
  classes: PropTypes.object,
  width: PropTypes.string,
  theme: PropTypes.object
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(Landing)
);
