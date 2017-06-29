import React from 'react';
import { mount, shallow } from 'enzyme';
import { JSDOM } from 'jsdom';
import { expect } from 'chai';

//global.document = new jsdom.JSDOM('<!doctype html><html><body></body></html>');
//global.window = document.parentWindow;

const dom = new JSDOM("");

global.window = dom.window;
global.document = dom.window.document;

function copyProps(src, target) {
  const props = Object.getOwnPropertyNames(src)
    .filter(prop => typeof target[prop] === 'undefined')
    .map(prop => Object.getOwnPropertyDescriptor(src, prop));
  Object.defineProperties(target, props);
}

copyProps(document.defaultView, global);


import WindowManager from '../src/client/app/window-manager';

describe('<WindowManager />', () => {
    //const wrapper = shallow(<WindowManager children={[<div id={0}/>]}><div /></WindowManager>);
    //const wrapper = mount(
    const wrapper = shallow(
      <WindowManager>
        <div id={0} />
      </WindowManager>
    );

    console.log(wrapper.state().stacks.toArray());

    it('should have one child', () => {
      expect(wrapper.state().stacks.toArray()).to.have.length(1);
    });

    console.log(wrapper.contains(<div id={0} />));

    it('should be a div', () => {
      expect(wrapper.contains(<div id={0} />)).to.equal(true);
    });
});

