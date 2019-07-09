<?php namespace Atlekbai\Contact;

use System\Classes\PluginBase;

class Plugin extends PluginBase
{
    public function registerComponents()
    {
	return [
		'Atlekbai\Contact\Components\ContactForm' => 'contactform',
	];
    }

    public function registerSettings()
    {
    }
}
