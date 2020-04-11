import React, { Component } from 'react';
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import CryptoApp from './CryptoApp';
import Home from './Home';
import logo from './Logo.svg';

class App extends Component {
	render() {
		return (
			<>
				<nav className='navbar navbar-expand navbar-dark fixed-top bg-dark '>
					<img src={logo} height='40' alt='' className='pr-5' />
					<button
						className='navbar-toggler'
						type='button'
						data-toggle='collapse'
						data-target='#navbarCollapse'
						aria-controls='navbarCollapse'
						aria-expanded='false'
						aria-label='Toggle navigation'
					>
						<span className='navbar-toggler-icon'></span>
					</button>
					<div className='collapse navbar-collapse' id='navbarCollapse'>
						<ul className='navbar-nav mr-auto'>
							<li className='nav-item '>
								<Link className='nav-link' to='/'>
									Home
								</Link>
							</li>
							<li className='nav-item'>
								<Link className='nav-link' to='/app'>
									App
								</Link>
							</li>
						</ul>
					</div>
				</nav>
				<Switch>
					<Switch>
						<Route path='/app'>
							<CryptoApp />
						</Route>
						<Route path='/'>
							<Home />
						</Route>
					</Switch>
				</Switch>
			</>
		);
	}
}

export default App;
