require IEx

defmodule Sydneytrains.Api do
  @moduledoc """
  The boundary for the Api system.
  """

  import Ecto.{Query, Changeset}, warn: false
  import Sydneytrains.DateUtils

  alias Sydneytrains.Repo

  alias Sydneytrains.Api.Route

  def list_routes do
    Repo.all(Route)
  end

  def get_route!(id), do: Repo.get!(Route, id)

  def create_route(attrs \\ %{}) do
    %Route{}
    |> route_changeset(attrs)
    |> Repo.insert()
  end

  def update_route(%Route{} = route, attrs) do
    route
    |> route_changeset(attrs)
    |> Repo.update()
  end

  def delete_route(%Route{} = route) do
    Repo.delete(route)
  end

  def change_route(%Route{} = route) do
    route_changeset(route, %{})
  end

  defp route_changeset(%Route{} = route, attrs) do
    route
    |> cast(attrs, [:route_id, :agency_id, :route_short_name, :route_long_name, :route_desc, :route_type, :route_url, :route_color, :route_text_color])
    |> validate_required([:route_id, :agency_id, :route_short_name, :route_long_name, :route_desc, :route_type, :route_url, :route_color, :route_text_color])
  end

  alias Sydneytrains.Api.Stop

  def list_stops do
    Repo.all(Stop)
  end

  def get_stop!(id), do: Repo.get!(Stop, id)

  def create_stop(attrs \\ %{}) do
    %Stop{}
    |> stop_changeset(attrs)
    |> Repo.insert()
  end

  def update_stop(%Stop{} = stop, attrs) do
    stop
    |> stop_changeset(attrs)
    |> Repo.update()
  end

  def delete_stop(%Stop{} = stop) do
    Repo.delete(stop)
  end

  def change_stop(%Stop{} = stop) do
    stop_changeset(stop, %{})
  end

  defp stop_changeset(%Stop{} = stop, attrs) do
    stop
    |> cast(attrs, [:stop_id, :stop_code, :stop_name, :stop_desc, :stop_lat, :stop_lon, :zone_id, :stop_url, :location_type, :parent_station, :stop_timezone, :wheelchair_boarding])
    |> validate_required([:stop_id, :stop_code, :stop_name, :stop_desc, :stop_lat, :stop_lon, :zone_id, :stop_url, :location_type, :parent_station, :stop_timezone, :wheelchair_boarding])
  end

  alias Sydneytrains.Api.Trip

  @doc """
  Returns the list of trips.

  ## Examples

      iex> list_trips()
      [%Trip{}, ...]

  """
  def list_trips do
    Repo.all(Trip)
  end

  def get_trip!(id), do: Repo.get!(Trip, id)

  def create_trip(attrs \\ %{}) do
    %Trip{}
    |> trip_changeset(attrs)
    |> Repo.insert()
  end

  def update_trip(%Trip{} = trip, attrs) do
    trip
    |> trip_changeset(attrs)
    |> Repo.update()
  end

  def delete_trip(%Trip{} = trip) do
    Repo.delete(trip)
  end

  def change_trip(%Trip{} = trip) do
    trip_changeset(trip, %{})
  end

  alias Sydneytrains.Api.TripDestination

  def list_trips_by_station_and_date(stop_ids, date) do
    time = current_time
    query = from t in TripDestination, 
      where: t.stop_id in ^stop_ids and t.date == type(^date, Ecto.Date) and t.departure_datetime >= type(^time, Ecto.DateTime),
      order_by: t.departure_time
    Repo.all(query)
  end

  defp trip_changeset(%Trip{} = trip, attrs) do
    trip
    |> cast(attrs, [:route_id, :service_id, :trip_id, :trip_headsign, :trip_short_name, :direction_id, :block_id, :shape_id, :wheelchair_accessible])
    |> validate_required([:route_id, :service_id, :trip_id, :trip_headsign, :trip_short_name, :direction_id, :block_id, :shape_id, :wheelchair_accessible])
  end

  alias Sydneytrains.Api.StopTime

  def list_stop_times do
    Repo.all(StopTime)
  end

  def get_stop_time!(id), do: Repo.get!(StopTime, id)

  def create_stop_time(attrs \\ %{}) do
    %StopTime{}
    |> stop_time_changeset(attrs)
    |> Repo.insert()
  end

  def update_stop_time(%StopTime{} = stop_time, attrs) do
    stop_time
    |> stop_time_changeset(attrs)
    |> Repo.update()
  end

  def delete_stop_time(%StopTime{} = stop_time) do
    Repo.delete(stop_time)
  end

  def change_stop_time(%StopTime{} = stop_time) do
    stop_time_changeset(stop_time, %{})
  end

  defp stop_time_changeset(%StopTime{} = stop_time, attrs) do
    stop_time
    |> cast(attrs, [:trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence, :stop_headsign, :pickup_type, :drop_off_type, :shape_dist_traveled])
    |> validate_required([:trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence, :stop_headsign, :pickup_type, :drop_off_type, :shape_dist_traveled])
  end

  alias Sydneytrains.Api.Station

  def list_stations do
    Repo.all(Station)
  end

  def get_station!(id), do: Repo.get!(Station, id)
  def get_station_with_stops(id), do: Repo.get!(Station, id) |> Repo.preload(:stops)

  alias Sydneytrains.Api.Service

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services do
    Repo.all(Service)
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(123)
      %Service{}

      iex> get_service!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(id), do: Repo.get!(Service, id)

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs \\ %{}) do
    %Service{}
    |> service_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Service{} = service, attrs) do
    service
    |> service_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Service.

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{source: %Service{}}

  """
  def change_service(%Service{} = service) do
    service_changeset(service, %{})
  end

  defp service_changeset(%Service{} = service, attrs) do
    service
    |> cast(attrs, [:service_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date])
    |> validate_required([:service_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date])
  end


end
