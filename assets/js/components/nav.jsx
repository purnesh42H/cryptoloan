import React from 'react';
import { NavLink } from 'react-router-dom';
import { Form, FormGroup, NavItem, Input, Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import api from './api';

let LoginForm = connect(({login}) => {return {login};})((props) => {
  function update(ev) {
    let tgt = $(ev.target);
    let data = {};
    data[tgt.attr('name')] = tgt.val();
    console.log("data in login form", tgt);
    props.dispatch({
      type: 'UPDATE_LOGIN_FORM',
      data: data,
    });
  }

  function create_token(ev) {
    api.submit_login(props.login);
    console.log(props.login);
  }

  return <div className="navbar-text">
    <Form inline>
      <FormGroup>
        <Input type="text" name="email" placeholder="email"
               value={props.login.email} onChange={update} />
      </FormGroup>
      <FormGroup>
        <Input type="password" name="pass" placeholder="password"
               value={props.login.pass} onChange={update} />
      </FormGroup>
      <Button onClick={create_token}>Log In</Button>
    </Form>
  </div>;
});


function reset_token(ev) {
    api.submit_logout();
}

let Session = connect(({token}) => {return {token};})((props) => {
  return <div className="navbar-text">
    User id = { props.token.user_id }
    <Button onClick={reset_token}>Logout</Button>          
    <Link className="btn btn-default btn-xs" to={"/auth/coinbase"} onClick={auth}>Coinbase</Link>
  </div>;
});

function auth(ev) {
  window.location.href("/auth/coinbase");
}
function Nav(props) {


  let session_info;
  if (props.token) {
    session_info = <Session token={props.token} />;
  }
  else {
    session_info = <LoginForm />
  }

  return (
    <nav className="navbar navbar-dark bg-dark navbar-expand">
      <span className="navbar-brand">
        Cryptoloan
      </span>
      <ul className="navbar-nav mr-auto">
        <NavItem>
          <NavLink to="/" exact={true} activeClassName="active" className="nav-link">Home</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to="/requestedloans" href="#" className="nav-link">All Loan Requests</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to="/loans" href="#" className="nav-link">All Loans</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to="/approvedloans" href="#" className="nav-link">My Loans</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to="/notifications" href="#" className="nav-link">Notifications</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to="/users" href="#" className="nav-link">Profile</NavLink>
        </NavItem>
	<NavItem>
          <span className="navbar-text">
	    { session_info }
          </span>
	</NavItem>
      </ul>
    </nav>
  );
}

function state2props(state) {
  return {
    token: state.token,
  };
}

export default connect(state2props)(Nav);

