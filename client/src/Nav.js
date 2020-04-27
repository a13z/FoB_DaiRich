/* eslint-disable jsx-a11y/anchor-is-valid */
import React from 'react';
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';

const Nav = () => (
	<Switch>
		<div>
			<nav className='navbar navbar-expand-lg navbar-light bg-light'>
				<a className='navbar-brand'>DaiRich</a>
				<button
					className='navbar-toggler'
					type='button'
					data-toggle='collapse'
					data-target='#navbarNav'
					aria-controls='navbarNav'
					aria-expanded='false'
					aria-label='Toggle navigation'
				>
					<span className='navbar-toggler-icon'></span>
				</button>
				<div className='collapse navbar-collapse' id='navbarNav'>
					<ul className='navbar-nav'>
						<li className='nav-item active'>
							<Link to='/'>Home</Link>
						</li>
						<li className='nav-item'>
							<Link to='/app'>App</Link>
						</li>
					</ul>
				</div>
			</nav>
		</div>
	</Switch>
);

export default Nav;
