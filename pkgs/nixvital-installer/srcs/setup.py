import setuptools

setuptools.setup(
    name='nixvital-installer',
    version='1.0.0',
    description='The nixvital OS installer',
    author='Break Yang',
    author_email='breakds@gmail.com',
    packages=setuptools.find_packages(),
    py_modules=['install'],
    entry_points={
        'console_scripts': [
            'nixvital_install=install:main',
        ],
    },
    python_requires='>=3.6',
)
