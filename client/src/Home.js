import React, { Component } from 'react';
import logo from './logo-black.svg';
import control from './adjust.svg';
import robot from './robot.svg';
import brain from './brain.svg';
import fb from './facebook.svg';
import tw from './twitter.svg';

class Home extends Component {
	render() {
		return (
			<>
				<div className='position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light'>
					<div className='col-md-5 p-lg-5 mx-auto my-5'>
						<h1 className='display-5 font-weight-normal'>
							The easy way to start investing in DeFi.
						</h1>
						<label htmlFor='inputEmail' className='sr-only'>
							Email address
						</label>
						<div className='input-group mt-3'>
							<input
								type='email'
								id='inputEmail'
								className='form-control'
								placeholder='Email address'
								required
								autoFocus
							></input>
							<a className='btn btn-warning ml-1' href='#'>
								Sign-up
							</a>
						</div>
					</div>
					<div className='product-device shadow-sm d-none d-md-block'></div>
					<div className='product-device product-device-2 shadow-sm d-none d-md-block'></div>
				</div>
				<div className='d-md-flex flex-md-equal w-100 my-md-3 pl-md-3'>
					<div className='bg-dark mr-md-3 pt-3 px-3 pt-md-5 px-md-5 text-center text-white overflow-hidden'>
						<div className='my-3 py-3'>
							<h2 className='display-5'>Total control</h2>
							<p className='lead'>
								Set your level of investing based on your risk appetite.
							</p>
						</div>
						<div
							className='bg-light shadow-sm mx-auto text-center '
							style={{
								width: '80%',
								height: '300px',
								borderRadius: '21px 21px 0 0',
							}}
						>
							<img src={control} height='150px' style={{ marginTop: '25%' }} />
						</div>
					</div>
					<div className='bg-light mr-md-3 pt-3 px-3 pt-md-5 px-md-5 text-center overflow-hidden'>
						<div className='my-3 p-3'>
							<h2 className='display-5'>Smart investing</h2>
							<p className='lead'>
								All DAI above your threshold are invested via Aave.
							</p>
						</div>
						<div
							className='bg-dark shadow-sm mx-auto'
							style={{
								width: '80%',
								height: '300px',
								borderRadius: '21px 21px 0 0',
							}}
						>
							<img src={brain} height='250px' style={{ marginTop: '20%' }} />
						</div>
					</div>
				</div>

				<div className='d-md-flex flex-md-equal w-100 my-md-3 pl-md-3'>
					<div className='bg-light mr-md-3 pt-3 px-3 pt-md-5 px-md-5 text-center overflow-hidden'>
						<div className='my-3 p-3'>
							<h2 className='display-5'>Automated</h2>
							<p className='lead'>
								Automatically liquidates your investment when your spendable
								balance gets low.
							</p>
						</div>
						<div
							className='bg-dark shadow-sm mx-auto'
							style={{
								width: '80%',
								height: '300px',
								borderRadius: '21px 21px 0 0',
							}}
						>
							<img src={robot} height='200px' style={{ marginTop: '25%' }} />
						</div>
					</div>
					<div className='bg-primary mr-md-3 pt-3 px-3 pt-md-5 px-md-5 text-center text-white overflow-hidden'>
						<div className='my-3 py-3'>
							<h2 className='display-5'>Want more DeFi earnings?</h2>
							<p className='lead'>Refer more friends.</p>
						</div>
						<div
							className='bg-light shadow-sm mx-auto'
							style={{
								width: '80%',
								height: '300px',
								borderRadius: '21px 21px 0 0',
							}}
						>
							<img src={fb} height='150px' style={{ marginTop: '10%' }} />
							<img src={tw} height='150px' style={{ marginTop: '10%' }} />
						</div>
					</div>
				</div>
				<footer className='container py-5'>
					<div className='row'>
						<div className='col-12 col-md'>
							<img src={logo} height='40px' />
							<small className='d-block mb-3 text-muted'>&copy; 2020</small>
						</div>
					</div>
				</footer>
			</>
		);
	}
}

export default Home;
