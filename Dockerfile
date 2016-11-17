FROM python:3.5
COPY requirements.txt /requirements.txt
COPY requirements-dev.txt /requirements-dev.txt
RUN python -m pip install -U pip
RUN python -m pip install -r requirements.txt
COPY ./ /code
WORKDIR /code
RUN apt-get update && apt-get install -y postgresql postgresql-contrib
RUN python manage.py migrate
#RUN python manage.py loaddatasets
#RUN python manage.py loadsuppliers
#RUN python manage.py ceapdatasets
#RUN python manage.py assets build
# RUN python manage.py collectstatic --no-input
CMD cp -r /assets/jarbas/* /code/jarbas/ && \
    python manage.py collectstatic --no-input && \
    gunicorn jarbas.wsgi:application --reload --bind 0.0.0.0:8001 --workers 4
