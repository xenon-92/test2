FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 442
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:442

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["test2.csproj", "./"]
RUN dotnet restore "test2.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "test2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test2.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test2.dll"]
