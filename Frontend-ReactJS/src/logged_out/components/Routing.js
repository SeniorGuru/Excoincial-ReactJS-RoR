import React, { memo } from "react";
import PropTypes from "prop-types";
import { Switch } from "react-router-dom";
import PropsRoute from "../../shared/components/PropsRoute";
import Home from "./home/Home";
import Markets from "./markets/Markets";
import Exchange from "./exchange/Exchange";
import Blog from "./blog/Blog";
import BlogPost from "./blog/BlogPost";

function Routing(props) {
  const {
    blogPosts,
    selectBlog,
    selectHome,
    selectMarkets,
    selectExchange,
    LiveChart,
    statistics,
  } = props;
  return (
    <Switch>
      {blogPosts.map(post => (
        <PropsRoute
          /* We cannot use the url here as it contains the get params */
          path={post.url}
          component={BlogPost}
          title={post.title}
          key={post.title}
          src={post.imageSrc}
          date={post.date}
          content={post.content}
          otherArticles={blogPosts.filter(blogPost => blogPost.id !== post.id)}
        />
      ))}
      <PropsRoute
        exact
        path="/blog"
        component={Blog}
        selectBlog={selectBlog}
        blogPosts={blogPosts}
      />
      <PropsRoute
        exact
        path="/"
        component={Home}
        LiveChart={LiveChart}
        statistics={statistics}
        selectHome={selectHome}
      />
      <PropsRoute
        exact
        path="/markets"
        component={Markets}
        selectMarkets={selectMarkets}
      />
      <PropsRoute
        exact
        path="/exchange"
        component={Exchange}
        selectExchange={selectExchange}
      />
    </Switch>
  );
}

Routing.propTypes = {
  blogposts: PropTypes.arrayOf(PropTypes.object),
  selectHome: PropTypes.func.isRequired,
  selectMarkets: PropTypes.func.isRequired,
  selectExchange: PropTypes.func.isRequired,
  selectBlog: PropTypes.func.isRequired
};

export default memo(Routing);
