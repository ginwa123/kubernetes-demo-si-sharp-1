# Use official .NET runtime as base
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 4021
EXPOSE 4022
EXPOSE 4023

# Build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["kubernetes-demo-si-sharp-1.csproj", "./app/"]
WORKDIR /src/app
RUN dotnet restore "kubernetes-demo-si-sharp-1.csproj"

# Copy everything and build
COPY . .
RUN dotnet publish "kubernetes-demo-si-sharp-1.csproj" -c Release -o /app/publish

# Verify the published files are there
RUN ls /app/publish  # You can remove this after verifying

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "kubernetes-demo-si-sharp-1.dll"]  # Match the actual DLL name
